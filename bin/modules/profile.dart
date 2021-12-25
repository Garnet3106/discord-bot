import 'package:nyxx/nyxx.dart';
import 'package:yaml/yaml.dart';
import 'module.dart';
import '../TestBOT.dart';
import '../command.dart';

class Profile {
  static int maxProfileNameLen = 50;

  Snowflake authorId;
  DateTime createdAt;
  List<ModuleProfile> modProfiles = [];

  Profile(this.authorId, this.createdAt) {}

  static Profile fromYamlNode(YamlNode node) {
    return Profile(Snowflake(node.value['authorId']),
        DateTime.fromMillisecondsSinceEpoch(node.value['createdAt']));
  }

  String toYamlText(String name) {
    List<String> lines = [];

    lines.add('  ${name}:');
    lines.add('    authorId: ${this.authorId}');
    lines.add('    createdAt: ${this.createdAt.millisecondsSinceEpoch}');

    return lines.join('\n');
  }
}

class ModuleProfile {
  String modName;

  ModuleProfile(this.modName);
}

class ProfileModule {
  static void run(Command cmd) {
    switch (cmd.cmdName) {
      case 'add':
        final profileName = cmd.getArgumentAt(1);

        if (profileName.length > Profile.maxProfileNameLen) {
          throw 'Profile name is too long';
        }

        var newProfile = Profile(cmd.msg.author.id, DateTime.now());
        profiles[profileName] = newProfile;

        var embed = EmbedBuilder();
        embed.author = Module.getEmbedAuthor(cmd.msg.author);
        embed.description = 'Profile \'${profileName}\' has been added.';
        embed.title = 'Profile Data';

        cmd.getChannel().sendMessage(MessageBuilder.embed(embed));

        print('[event] Profile \'${profileName}\' has been added.');
        break;
      case 'save':
        saveBotData();

        var embed = EmbedBuilder();
        embed.author = Module.getEmbedAuthor(cmd.msg.author);
        embed.description = 'Profile data was saved successfully.';
        embed.title = 'Profile Data';

        cmd.getChannel().sendMessage(MessageBuilder.embed(embed));
        break;
    }
  }
}
