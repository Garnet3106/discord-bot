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
        var embed = EmbedBuilder();
        embed.author = Module.getEmbedAuthor(cmd.msg.author);
        embed.description = 'disconnecting...';
        embed.title = 'BOT Operation';
        var msg = MessageBuilder.embed(embed);
        cmd.msg.channel
            .getFromCache()
            ?.sendMessage(msg)
            ?.then((_value) => saveBotData())
            ?.then((_value) => bot.dispose());
        break;
    }
  }

  static void sendHelp(TextChannel channel, IMessageAuthor author) {
    var embed = EmbedBuilder();
    embed.author = Module.getEmbedAuthor(author);
    embed.description = 'command list';
    embed.title = 'Command Help - bot';

    var msg = MessageBuilder.embed(embed);
    channel.sendMessage(msg);
  }
}
