import 'package:nyxx/nyxx.dart';
import '../command.dart';

class BotModule {
  static void run(Command cmd) {
    switch (cmd.cmdName) {
      case 'help':
        BotModule.sendHelp(cmd.get_channel());
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

  static void sendHelp(TextChannel channel) {
    var embed = EmbedBuilder();
    embed.title = 'Command Help - bot';
    embed.description = 'command list';
    var msg = MessageBuilder.embed(embed);
    channel.sendMessage(msg);
  }
}
