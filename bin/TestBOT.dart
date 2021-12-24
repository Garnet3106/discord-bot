import 'package:nyxx/nyxx.dart';
import 'command.dart';
import 'modules/bot.dart';
import 'modules/time.dart';

const token = 'OTIyMTAyNjEzODcxMzE2OTky.Yb8k-g.XElWhgQdDpPO1ewG5ml7fDtBEq0';

void main() {
  final bot = Nyxx(token, GatewayIntents.allUnprivileged);

  bot.onMessageReceived.listen(onMessageReceive);
}

void onMessageReceive(MessageReceivedEvent event) {
  if (event.message.author.bot) return;

  // todo: ダブルクォーテーションに対応
  final args = event.message.content.split(" ");
  final cmd_chain = args[0].split(".");

  if (cmd_chain.length == 2) {
    var cmd = Command(cmd_chain[0], cmd_chain[1], args, event.message);

    switch (cmd.modName.toLowerCase()) {
      case "bot":
        BotModule.run(cmd);
        break;
      case "time":
        TimeModule.run(cmd);
        break;
    }
  }
}
