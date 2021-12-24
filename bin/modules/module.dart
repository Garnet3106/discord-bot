import 'package:nyxx/nyxx.dart';
import '../command.dart';

mixin Module {
  static void run(Command cmd) {}

  static void sendHelp(TextChannel channel) {}
}
