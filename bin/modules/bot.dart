import 'package:nyxx/nyxx.dart';
import 'module.dart';
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
            EmbedFieldElement('exit', 'exit the bot application', true),
          ],
        );
        break;
      case 'exit':
        var embed = EmbedBuilder();
        embed.title = 'BOT Operation';
        embed.description = 'exiting...';
        var msg = MessageBuilder.embed(embed);
        cmd.msg.channel.getFromCache()?.sendMessage(msg);
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
