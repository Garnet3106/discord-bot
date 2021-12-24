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
            EmbedFieldElement('pin', 'pin a new message', true),
          ],
        );
        break;
      case 'pin':
        var embed = EmbedBuilder();
        embed.author = Module.getEmbedAuthor(cmd.msg.author);
        embed.description = cmd.msg.content.substring('${modName}.pin'.length);
        embed.title = 'Pin Message';

        var msg = MessageBuilder.embed(embed);

        cmd
            .getChannel()
            .sendMessage(msg)
            .then((sentMsg) => sentMsg.pinMessage());
        break;
    }
  }
}
