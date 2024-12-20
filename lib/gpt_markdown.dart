library gpt_markdown;

import 'package:flutter/material.dart';
import 'package:gpt_markdown/custom_widgets/markdow_config.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter_math_fork/flutter_math.dart';
import 'package:gpt_markdown/custom_widgets/custom_divider.dart';
import 'package:gpt_markdown/custom_widgets/custom_error_image.dart';
import 'package:gpt_markdown/custom_widgets/custom_rb_cb.dart';
import 'package:gpt_markdown/custom_widgets/selectable_adapter.dart';
import 'package:gpt_markdown/custom_widgets/unordered_ordered_list.dart';
import 'dart:math';

import 'custom_widgets/code_field.dart';
import 'custom_widgets/link_button.dart';

part 'theme.dart';
part 'markdown_component.dart';
part 'md_widget.dart';

/// This widget create a full markdown widget as a column view.
class GptMarkdown extends StatelessWidget {
  const GptMarkdown(
    this.data, {
    super.key,
    this.style,
    this.followLinkColor = false,
    this.textDirection = TextDirection.ltr,
    this.latexWorkaround,
    this.textAlign,
    this.textScaler,
    this.onLinkTab,
    this.latexBuilder,
    this.codeBuilder,
    this.sourceTagBuilder,
    this.maxLines,
    this.overflow,
  });
  final TextDirection textDirection;
  final String data;
  final TextStyle? style;
  final TextAlign? textAlign;
  final TextScaler? textScaler;
  final void Function(String url, String title)? onLinkTab;
  final String Function(String tex)? latexWorkaround;
  final int? maxLines;
  final TextOverflow? overflow;
  final Widget Function(
          BuildContext context, String tex, TextStyle style, bool inline)?
      latexBuilder;
  final bool followLinkColor;
  final Widget Function(BuildContext context, String name, String code)?
      codeBuilder;
  final Widget Function(BuildContext, String, TextStyle)? sourceTagBuilder;

  @override
  Widget build(BuildContext context) {
    String tex = data.trim();
    if (!tex.contains(r"\(")) {
      tex = tex
          .replaceAllMapped(
              RegExp(
                r"(?<!\\)\$\$(.*?)(?<!\\)\$\$",
                dotAll: true,
              ),
              (match) => "\\[${match[1] ?? ""}\\]")
          .replaceAllMapped(
              RegExp(
                r"(?<!\\)\$(.*?)(?<!\\)\$",
              ),
              (match) => "\\(${match[1] ?? ""}\\)");
      tex = tex.splitMapJoin(
        RegExp(r"\[.*?\]|\(.*?\)"),
        onNonMatch: (p0) {
          return p0.replaceAll("\\\$", "\$");
        },
      );
    }
    return ClipRRect(
        child: MdWidget(
      tex,
      config: GptMarkdownConfig(
        textDirection: textDirection,
        style: style,
        onLinkTab: onLinkTab,
        textAlign: textAlign,
        textScaler: textScaler,
        followLinkColor: followLinkColor,
        latexWorkaround: latexWorkaround,
        latexBuilder: latexBuilder,
        codeBuilder: codeBuilder,
        maxLines: maxLines,
        overflow: overflow,
        sourceTagBuilder: sourceTagBuilder,
      ),
    ));
  }
}
