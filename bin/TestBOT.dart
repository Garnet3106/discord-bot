import 'package:dotenv/dotenv.dart' as DotEnv;
import 'package:nyxx/nyxx.dart';

import 'command.dart';
import 'modules/bot.dart';
import 'modules/time.dart';
import 'modules/message.dart';

var bot;
var deleteNextMsg = false;

void main() {
  DotEnv.load();
  final token = DotEnv.env['BOT_TOKEN'];
  bot = Nyxx(token, GatewayIntents.allUnprivileged);

  bot.onReady.listen(onReady);
  bot.onMessageReceived.listen(onMessageReceive);
}

void onReady(ReadyEvent event) {}

void onMessageReceive(MessageReceivedEvent event) {
  final msg = event.message;

  if (deleteNextMsg) {
    msg.delete();
    deleteNextMsg = false;
  }

  if (msg.author.bot) return;

  // todo: ダブルクォーテーションに対応
  final args = msg.content.split(' ');
  final cmd_chain = args[0].split('.');

  if (cmd_chain.length == 2) {
    var cmd = Command(cmd_chain[0], cmd_chain[1], args, msg);

    switch (cmd.modName.toLowerCase()) {
      case 'bot':
        BotModule.run(cmd);
        break;
      case 'msg':
        MessageModule.run(cmd);
        break;
      case 'time':
        TimeModule.run(cmd);
        break;
    }
  }
}
