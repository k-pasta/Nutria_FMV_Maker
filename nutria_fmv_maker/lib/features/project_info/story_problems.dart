// How the editor names the problems the export finds in the main branch
// (the part of the story the origin reaches), and the nodes they're on.
import 'package:nutria_fmv_maker/core/document/node.dart';
import 'package:nutria_fmv_maker/core/document/project_document.dart';
import 'package:nutria_fmv_maker/core/protocol/fmv_exporter.dart';
import 'package:nutria_fmv_maker/features/nodes/widgets/logic_node_views.dart';
import 'package:nutria_fmv_maker/l10n/generated/app_localizations.dart';

/// What a problem of [type] is, in a few words.
String exportIssueText(ExportIssueType type, AppLocalizations t) =>
    switch (type) {
      ExportIssueType.missingVideo => t.issueMissingVideo,
      ExportIssueType.unconnectedChoice => t.issueUnconnectedChoice,
      ExportIssueType.invalidLogic => t.issueInvalidLogic,
      ExportIssueType.singleChoice => t.issueSingleChoice,
    };

/// A node as the author knows it: its name, else what its strip shows,
/// else its video's file name.
String nodeLabel(ProjectDocument doc, Node node, AppLocalizations t) =>
    node.name ??
    switch (node) {
      OriginNode() => t.nodeOriginDefaultName,
      _ when node.isLogicNode => logicNodeTitle(node, t),
      _ => doc.mediaById(node.videoIdOrNull)?.fileName ?? t.nodeUntitled,
    };

/// [issue] as one line: the node, then the problem.
String exportIssueLine(
  ProjectDocument doc,
  ExportIssue issue,
  AppLocalizations t,
) => switch (doc.nodes[issue.nodeId]) {
  final node? =>
    '${nodeLabel(doc, node, t)}: ${exportIssueText(issue.type, t)}',
  null => exportIssueText(issue.type, t),
};
