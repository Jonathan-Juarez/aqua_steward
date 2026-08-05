import 'package:flutter/widgets.dart';
import 'package:socket_io_client/socket_io_client.dart' as io;
import 'package:aqua_steward/core/network/global_variable.dart';

class SocketService {
  io.Socket? socket;
  Function(String, String, double)? onDataReceived;

  // Conecta al backend
  Future<void> connect(Function(String, String, double) onData) async {
    onDataReceived = onData;

    String backendUrl = uri;

    // Se conecta al backend por Socket.IO, pero no se conecta automaticamente, sino que hasta que se solicite (entrar al dashboard).
    socket = io.io(backendUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket!.connect();

    socket!.onConnect((_) {
      debugPrint('Conectado al Backend (Socket.IO)');
    });

    ListenerSensor("deposit_level_update", "litros", "level");
    ListenerSensor("deposit_ph_update", "ph", "ph");
    ListenerSensor("deposit_turbidity_update", "ntu", "turbidity");

    socket!.onDisconnect((_) {
      debugPrint('Desconectado del Backend (Socket.IO)');
    });

    socket!.onError((error) {
      debugPrint('Error en Socket.IO: $error');
    });
  }

  void ListenerSensor(String event, String key, String parameter) {
    socket!.on(event, (data) {
      if (data != null && data is Map<String, dynamic>) {
        final ip = data['ip'] as String?;
        final value = (data[key] as num?)?.toDouble();

        if (ip != null && value != null) {
          if (onDataReceived != null) {
            onDataReceived!(ip, parameter, value);
          }
        }
      }
    });
  }

  // Se une a una sala del socket por IP, en caso de tener varios kits.
  void subscribeTo(String ipDeposito) {
    // socket?.emit('subscribe_to_ip', {'ip': ipDeposito});
  }

  void disconnect() {
    socket?.disconnect();
  }
}
