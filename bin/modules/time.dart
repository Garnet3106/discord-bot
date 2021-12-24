import 'package:nyxx/nyxx.dart';
import '../command.dart';

class TimeModule {
  static void run(Command cmd) {
    var msgBuilder = MessageBuilder();

    switch (cmd.cmdName) {
      case "show":
        msgBuilder.content = DateTime.now().toIso8601String();
        cmd.msg.channel.getFromCache()?.sendMessage(msgBuilder);
        break;
      case "exit":
        TimeModule.sendHelp(cmd.get_channel());
        break;
    }
  }

  static void sendHelp(TextChannel channel) {
    var embed = EmbedBuilder();
    embed.title = "Command Help - time";
    embed.description = "command list";
    var msg = MessageBuilder.embed(embed);
    channel.sendMessage(msg);
  }
}
