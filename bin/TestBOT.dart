import 'dart:io';

import 'package:dotenv/dotenv.dart' as DotEnv;
import 'package:nyxx/nyxx.dart';
import 'package:yaml/yaml.dart' as Yaml;

import 'command.dart';
import 'modules/bot.dart';
import 'modules/module.dart';
import 'modules/profile.dart';
import 'modules/time.dart';
import 'modules/message.dart';

late Nyxx bot;
Map<String, Profile> profiles = {};
bool deleteNextMsg = false;

void main() {
  DotEnv.load();
  final String token = DotEnv.env['BOT_TOKEN'] ??
      terminate('Environment variable \'BOT_TOKEN\' not found.');
  bot = Nyxx(token, GatewayIntents.allUnprivileged);

  bot.onReady.listen(onReady);
  bot.onMessageReceived.listen(onMessageReceive);
}

dynamic terminate(String msg) {
  print('[err] ${msg}');
  bot.dispose();
}

void onReady(ReadyEvent event) {
  loadBotData();
  print('[event] Bot is ready.');
}

void loadBotData() {
  try {
    final String botDataPath = DotEnv.env['BOT_DATA_PATH'] ??
        terminate('Environment variable \'BOT_DATA_PATH\' not found.');

    String botDataSrc = new File(botDataPath).readAsStringSync();
    Yaml.YamlMap yamlMap = Yaml.loadYaml(botDataSrc);
    Yaml.YamlNode? profilesNode = yamlMap.nodes['profiles'];

    profilesNode?.value?.forEach((key, node) {
      profiles[key] = Profile.fromYamlNode(node);
    });
  } catch (e) {
    terminate('Failed to load bot data.');
  }

  print('[event] Bot data has been loaded.');
}

void saveBotData() {
  try {
    final String botDataPath = DotEnv.env['BOT_DATA_PATH'] ??
        terminate('Environment variable \'BOT_DATA_PATH\' not found.');

    List<String> lines = [];
    profiles.forEach((key, value) => lines.add(value.toYamlText(key)));
    new File(botDataPath).writeAsStringSync('profiles:\n' + lines.join('\n'));
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

    try {
      switch (cmd.modName.toLowerCase()) {
        case 'bot':
          BotModule.run(cmd);
          break;
        case 'msg':
          MessageModule.run(cmd);
          break;
        case 'prof':
          ProfileModule.run(cmd);
          break;
        case 'time':
          TimeModule.run(cmd);
          break;
      }
    } catch (e) {
      if (e is String) {
        print('[mod] exception message on module: ${e}');
        var embed = Module.getEmbed(cmd.msg.author, '[Error]', e);
        cmd.getChannel().sendMessage(MessageBuilder.embed(embed));
      }
    }
  }
}
