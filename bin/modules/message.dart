import 'package:nyxx/nyxx.dart';
import 'module.dart';
import '../command.dart';

class MessageModule {
  static String modName = 'msg';

  static void run(Command cmd) {
    switch (cmd.cmdName) {
      case 'help':
        Module.sendHelp(
          cmd.getChannel(),
          cmd.msg.author,
          modName,
          [
            EmbedFieldElement('help', 'show command help', true),
            EmbedFieldElement('pin <msg>', 'pin a new message', true),
          ],
        );
        break;
      case 'pin':
        var embed = Module.getEmbed(cmd.msg.author, 'Pin Message',
            cmd.msg.content.substring('${modName}.pin'.length));
        var msg = MessageBuilder.embed(embed);

        cmd
            .getChannel()
            .sendMessage(msg)
            .then((sentMsg) => sentMsg.pinMessage());
        break;
    }
  }
}
