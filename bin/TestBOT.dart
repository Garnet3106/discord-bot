import 'dart:io';

import 'package:dotenv/dotenv.dart' as DotEnv;
import 'package:nyxx/nyxx.dart';
import 'package:yaml/yaml.dart' as Yaml;

import 'command.dart';
import 'modules/bot.dart';
import 'modules/time.dart';
import 'modules/message.dart';

Nyxx bot;
Yaml.YamlMap botData;
bool deleteNextMsg = false;

void main() {
  DotEnv.load();
  final String token = DotEnv.env['BOT_TOKEN'];
  bot = Nyxx(token, GatewayIntents.allUnprivileged);

  bot.onReady.listen(onReady);
  bot.onMessageReceived.listen(onMessageReceive);
}

void onReady(ReadyEvent event) {
  loadBotData();
  print('[event] Bot is ready.');
}

void loadBotData() {
  try {
    String botDataSrc =
        new File(DotEnv.env['BOT_DATA_PATH']).readAsStringSync();
    botData = Yaml.loadYaml(botDataSrc);
  } catch (_e) {
    print('[err] Failed to load bot data.');
    bot.dispose();
  }

  print('[event] Bot data has been loaded.');
}

void saveBotData() {
  try {
    new File(DotEnv.env['BOT_DATA_PATH']).writeAsStringSync(botData.toString());
  } catch (_e) {
    print('[err] Failed to save bot data.');
  }

  print('[event] Bot data has been saved.');
}

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
