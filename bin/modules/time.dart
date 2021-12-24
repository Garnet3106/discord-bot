import 'package:nyxx/nyxx.dart';
import 'module.dart';
import '../command.dart';

class TimeModule {
  static String modName = 'time';

  static void run(Command cmd) {
    var msgBuilder = MessageBuilder();

    switch (cmd.cmdName) {
      case 'show':
        msgBuilder.content = DateTime.now().toIso8601String();
        cmd.msg.channel.getFromCache()?.sendMessage(msgBuilder);
        break;
      case 'exit':
        TimeModule.sendHelp(cmd.getChannel(), cmd.msg.author);
        break;
    }
  }

  static void sendHelp(TextChannel channel, IMessageAuthor author) {
    var embed = EmbedBuilder();
    embed.author = Module.getEmbedAuthor(author);
    embed.description = 'command list';
    embed.title = 'Command Help - time';

    var msg = MessageBuilder.embed(embed);
    channel.sendMessage(msg);
  }
}
