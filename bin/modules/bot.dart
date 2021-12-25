import 'package:nyxx/nyxx.dart';
import 'module.dart';
import '../TestBOT.dart';
import '../command.dart';

class BotModule {
  static String modName = 'bot';

  static void run(Command cmd) {
    switch (cmd.cmdName) {
      case 'help':
        Module.sendHelp(
          cmd.getChannel(),
          cmd.msg.author,
          modName,
          [
            EmbedFieldElement('help', 'show command help', true),
            EmbedFieldElement('dis', 'disconnect the bot application', true),
          ],
        );
        break;
      case 'dis':
        var embed = Module.getEmbed(cmd.msg.author, 'Bot Operation',
            'Bot will be disconnected soon...');
        var msg = MessageBuilder.embed(embed);
        cmd
            .getChannel()
            .sendMessage(msg)
            .then((_value) => saveBotData())
            .then((_value) => bot.dispose());
        break;
    }
  }
}
