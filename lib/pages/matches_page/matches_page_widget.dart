import '/components/lookaround_bottom_nav_widget.dart';
import '/floter/floter_icon_button.dart';
import '/floter/floter_theme.dart';
import '/floter/floter_util.dart';
import '/backend/supabase/supabase.dart';
import '/index.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import '/models/chat_models.dart';
import 'matches_page_model.dart';
export 'matches_page_model.dart';

class MatchesPageWidget extends StatefulWidget {
  const MatchesPageWidget({super.key});

  static String routeName = 'MatchesPage';
  static String routePath = '/matches';

  @override
  State<MatchesPageWidget> createState() => _MatchesPageWidgetState();
}

class _MatchesPageWidgetState extends State<MatchesPageWidget> {
  late MatchesPageModel _model;

  final scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _model = createModel(context, () => MatchesPageModel());
    _model.onStateChanged = () => safeSetState(() {});
  }

  @override
  void dispose() {
    _model.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = FloterTheme.of(context);

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: theme.primaryBackground,
      body: SafeArea(
        top: true,
        child: Column(
          children: [
            Expanded(
              child: _model.isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _model.conversations.isEmpty
                      ? _buildEmptyState(context, theme)
                      : _buildConversationList(context, theme),
            ),
            wrapWithModel(
              model: _model.lookaroundBottomNavModel,
              updateCallback: () => safeSetState(() {}),
              child: const LookaroundBottomNavWidget(activeTab: 'Chats'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, dynamic theme) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            AppLabels.of(context).get('matches.no_chats_yet'),
            style: GoogleFonts.inter(
              color: theme.secondaryText,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConversationList(BuildContext context, dynamic theme) {
    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(23, 36, 23, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildHeader(context, theme),
          const SizedBox(height: 24),
          Expanded(
            child: ListView.separated(
              itemCount: _model.conversations.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (context, index) =>
                  _buildConversationItem(context, _model.conversations[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context, dynamic theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          AppLabels.of(context).get('matches.chats'),
          style: GoogleFonts.interTight(
            color: const Color(0xFF9400D3),
            fontSize: 24,
            fontWeight: FontWeight.w700,
          ),
        ),
        FloterIconButton(
          borderRadius: 8,
          buttonSize: 40,
          fillColor: theme.primaryBackground,
          icon: Icon(
            Icons.settings,
            color: theme.primaryText,
            size: 24,
          ),
          onPressed: () async {
            await context.pushNamed('AccountSettingsPage');
          },
        ),
      ],
    );
  }

  Widget _buildConversationItem(BuildContext context, Conversation conv) {
    final theme = FloterTheme.of(context);
    final currentUserId = SupaFlow.client.auth.currentUser?.id ?? '';
    final nameText = StringBuffer(conv.otherUserName ?? '');
    if (conv.otherUserAge != null) {
      nameText.write(', ${conv.otherUserAge}');
    }

    final lastMsgText = () {
      final body = conv.lastMessageBody ?? '';
      if (body.isEmpty) return '';
      if (conv.lastMessageSenderId == currentUserId) {
        return 'You: $body';
      }
      return body;
    }();

    return Slidable(
      endActionPane: ActionPane(
        motion: const BehindMotion(),
        children: [
          SlidableAction(
            onPressed: (_) => _model.blockUser(conv),
            foregroundColor: const Color(0xFFF4442E),
            icon: Icons.block,
            label: 'Block',
          ),
          SlidableAction(
            onPressed: (_) => _model.deleteConversation(conv),
            foregroundColor: const Color(0xFF9400D3),
            icon: Icons.delete_outline,
            label: 'Delete',
          ),
          SlidableAction(
            onPressed: (_) => _model.reportUser(conv),
            foregroundColor: const Color(0xFF757575),
            icon: Icons.report_outlined,
            label: 'Report',
          ),
        ],
      ),
      child: InkWell(
        onTap: () async {
          await context.pushNamed(
            ChatPageWidget.routeName,
            queryParameters: {
              'conversationId': serializeParam(conv.id, ParamType.int),
            }.withoutNulls,
          );
        },
        child: Container(
          height: 90,
          padding: const EdgeInsetsDirectional.fromSTEB(9, 0, 4, 0),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(25),
                child: CachedNetworkImage(
                  fadeInDuration: Duration.zero,
                  fadeOutDuration: Duration.zero,
                  imageUrl: SupaFlow.safePhotoUrl(conv.otherUserAvatar) ?? '',
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  placeholder: (_, __) => Container(
                    color: theme.secondaryBackground,
                    child: const Icon(Icons.person, size: 40),
                  ),
                  errorWidget: (_, __, ___) => Container(
                    color: theme.secondaryBackground,
                    child: const Icon(Icons.person, size: 40),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      nameText.toString(),
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 16,
                        fontWeight:
                            conv.isUnread ? FontWeight.w700 : FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    Text(
                      lastMsgText,
                      style: GoogleFonts.inter(
                        color: Colors.black,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsetsDirectional.fromSTEB(4, 0, 0, 0),
                child: Image.asset(
                  conv.isUnread
                      ? 'assets/images/icon_chat_unread.png'
                      : 'assets/images/icon_chat_read.png',
                  height: 32,
                  fit: BoxFit.fitHeight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
