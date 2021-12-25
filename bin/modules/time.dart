import 'package:nyxx/nyxx.dart';
import 'module.dart';
import '../command.dart';

class TimeModule {
  static String modName = 'time';

  static void run(Command cmd) {
    var msgBuilder = MessageBuilder();

    switch (cmd.cmdName) {
      case 'help':
        Module.sendHelp(
          cmd.getChannel(),
          cmd.msg.author,
          modName,
          [
            EmbedFieldElement('help', 'show command help', true),
            EmbedFieldElement('show', 'show the current time', true),
          ],
        );
        break;
      case 'show':
        msgBuilder.content = DateTime.now().toIso8601String();
        cmd.getChannel().sendMessage(msgBuilder);
        break;
    }
  }
}
