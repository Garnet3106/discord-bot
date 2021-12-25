import 'package:nyxx/nyxx.dart';
import '../command.dart';

class EmbedFieldElement {
  String name;
  String content;
  bool inline = false;

  EmbedFieldElement(this.name, this.content, this.inline) {}
}

class Module {
  static void run(Command cmd) {}

  static void sendHelp(TextChannel channel, IMessageAuthor author,
      String cmdName, List<EmbedFieldElement> fields) {
    var embed = Module.getEmbed(author,
        '[${cmdName.toUpperCase()}] Command Help', 'command list', fields);

    var msg = MessageBuilder.embed(embed);
    channel.sendMessage(msg);
  }

  static EmbedBuilder getEmbed(IMessageAuthor author, String title, String desc,
      [List<EmbedFieldElement>? fields = null]) {
    var embed = EmbedBuilder();

    embed.author = Module.getEmbedAuthor(author);
    embed.description = desc;
    embed.title = title;

    fields?.forEach((element) {
      embed.addField(
        name: element.name,
        content: element.content,
        inline: element.inline,
      );
    });

    return embed;
  }

  static EmbedAuthorBuilder getEmbedAuthor(IMessageAuthor author) {
    var builder = EmbedAuthorBuilder();
    builder.iconUrl = author.avatarURL();
    builder.name = author.username;
    return builder;
  }
}
