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

    // Se conecta al backend por Socket.IO, pero no se conecta automaticamente, sino que hasta que se solicite (entre al dashboard).
    socket = io.io(backendUrl, <String, dynamic>{
      'transports': ['websocket'],
      'autoConnect': false,
    });

    socket!.connect();

    socket!.onConnect((_) {
      debugPrint('Conectado al Backend (Socket.IO)');
    });

    // Escucha el evento nivel que emitirá el backend.
    socket!.on('deposit_level_update', (data) {
      if (data != null && data is Map<String, dynamic>) {
        final ip = data['ip'] as String?;
        final nivelLitros = (data['litros'] as num?)?.toDouble();

        if (ip != null && nivelLitros != null) {
          if (onDataReceived != null) {
            onDataReceived!(ip, 'level', nivelLitros);
          }
        }
      }
    });

    // Escucha el evento pH que emitirá el backend.
    socket!.on('deposit_ph_update', (data) {
      if (data != null && data is Map<String, dynamic>) {
        final ip = data['ip'] as String?;
        final phValue = (data['ph'] as num?)?.toDouble();

        if (ip != null && phValue != null) {
          if (onDataReceived != null) {
            onDataReceived!(ip, 'ph', phValue);
          }
        }
      }
    });

    // Escucha el evento turbidez que emitirá el backend.
    socket!.on('deposit_turbidity_update', (data) {
      if (data != null && data is Map<String, dynamic>) {
        final ip = data['ip'] as String?;
        final ntuValue = (data['ntu'] as num?)?.toDouble();

        if (ip != null && ntuValue != null) {
          if (onDataReceived != null) {
            onDataReceived!(ip, 'turbidity', ntuValue);
          }
        }
      }
    });

    socket!.onDisconnect((_) {
      debugPrint('Desconectado del Backend (Socket.IO)');
    });

    socket!.onError((error) {
      debugPrint('Error en Socket.IO: $error');
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
