import 'package:extended_sliver/extended_sliver.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mikan_flutter/internal/extension.dart';
import 'package:mikan_flutter/mikan_flutter_routes.dart';
import 'package:mikan_flutter/model/season.dart';
import 'package:mikan_flutter/model/year_season.dart';
import 'package:mikan_flutter/providers/index_model.dart';
import 'package:mikan_flutter/topvars.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:provider/provider.dart';

@immutable
class SelectSeasonFragment extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final IndexModel indexModel =
        Provider.of<IndexModel>(context, listen: false);
    return Material(
      color: theme.scaffoldBackgroundColor,
      child: NotificationListener(
        onNotification: (notification) {
          if (notification is OverscrollIndicatorNotification) {
            notification.disallowGlow();
          }
          return true;
        },
        child: CustomScrollView(
          shrinkWrap: true,
          controller: ModalScrollController.of(context),
          slivers: [
            _buildHeader(context, theme, indexModel),
            _buildSeasonItemList(theme, indexModel),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(
    final BuildContext context,
    final ThemeData theme,
    final IndexModel indexModel,
  ) {
    return SliverPinnedToBoxAdapter(
      child: Container(
        decoration: BoxDecoration(
          color: theme.backgroundColor,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.024),
              offset: Offset(0, 1),
              blurRadius: 3.0,
              spreadRadius: 3.0,
            ),
          ],
          borderRadius: BorderRadius.only(
            bottomLeft: Radius.circular(16.0),
            bottomRight: Radius.circular(16.0),
          ),
        ),
        padding: EdgeInsets.only(
          top: 16.0,
          left: 16.0,
          right: 16.0,
          bottom: 16.0,
        ),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                "年度番组",
                style: TextStyle(
                  fontSize: 20,
                  height: 1.25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            MaterialButton(
              onPressed: () {
                Navigator.pushNamed(
                  context,
                  Routes.seasonList.name,
                  arguments: Routes.seasonList.d(
                    years: indexModel.years,
                  ),
                );
              },
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              padding: EdgeInsets.all(8.0),
              child: Icon(
                FluentIcons.chevron_right_24_regular,
                size: 16.0,
              ),
              minWidth: 0,
              color: theme.scaffoldBackgroundColor,
              shape: CircleBorder(),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSeasonItem(
    final ThemeData theme,
    final Season season,
    final IndexModel indexModel,
  ) {
    return Flexible(
      child: FractionallySizedBox(
        widthFactor: 1,
        child: Padding(
          padding: edge8,
          child: Selector<IndexModel, Season?>(
            selector: (_, model) => model.selectedSeason,
            shouldRebuild: (pre, next) => pre != next,
            builder: (context, selectedSeason, _) {
              final Color color = season.title == selectedSeason?.title
                  ? theme.primaryColor
                  : theme.accentColor;
              return Tooltip(
                message: season.title,
                child: MaterialButton(
                  minWidth: 0,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  padding: EdgeInsets.all(0.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                  child: Text(
                    season.season,
                    style: TextStyle(
                      fontSize: 18.0,
                      height: 1.25,
                      fontWeight: FontWeight.w500,
                      color: color,
                    ),
                  ),
                  color: color.withOpacity(0.12),
                  elevation: 0,
                  onPressed: () {
                    indexModel.loadSeason(season);
                  },
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildSeasonItemList(
    final ThemeData theme,
    final IndexModel indexModel,
  ) {
    return SliverPadding(
      padding: edgeHB16T8,
      sliver: Selector<IndexModel, List<YearSeason>>(
        selector: (_, model) => model.years,
        shouldRebuild: (pre, next) => pre.ne(next),
        builder: (_, years, __) {
          if (years.isNullOrEmpty) return sliverToBoxAdapter;
          return SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, index) {
                final YearSeason year = years[index];
                return Row(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Flexible(
                      child: FractionallySizedBox(
                        widthFactor: 1,
                        child: Text(
                          year.year,
                          style: textStyle20B,
                        ),
                      ),
                    ),
                    ...List.generate(
                      4,
                      (index) {
                        if (year.seasons.length > index) {
                          return _buildSeasonItem(
                            theme,
                            year.seasons[index],
                            indexModel,
                          );
                        } else {
                          return Flexible(
                            child: FractionallySizedBox(widthFactor: 1),
                          );
                        }
                      },
                    ),
                  ],
                );
              },
              childCount: years.length,
            ),
          );
        },
      ),
    );
  }
}
