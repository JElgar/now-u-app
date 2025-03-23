import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:nowu/assets/constants.dart';
import 'package:nowu/models/cause.dart';
import 'package:nowu/ui/components/user_progress/bloc/user_progress_bloc.dart';
import 'package:nowu/ui/components/user_progress/bloc/user_progress_state.dart';
import 'package:nowu/ui/dialogs/cause/cause_dialog.dart';

class CauseTile extends StatelessWidget {
  final Cause cause;
  final IconData icon;
  final VoidCallback onSelect;
  final bool? isSelectedOverride;

  CauseTile({
    required this.cause,
    required this.onSelect,
    bool? this.isSelectedOverride,
  }) : this.icon = cause.icon;

  void openInfoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        return CauseInfoDialog(
          cause: cause,
          onSelectCause: onSelect,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onSelect,
      child: BlocBuilder<UserProgressBloc, UserProgressState>(
        buildWhen: (prev, curr) {
          // If we are overriding selection then we don't care about state
          if (isSelectedOverride != null) {
            return false;
          }

          return prev.causeIsSelected(cause.id) !=
              curr.causeIsSelected(cause.id);
        },
        builder: (context, state) {
          final isSelected =
              isSelectedOverride ?? state.causeIsSelected(cause.id);

          return Container(
            decoration: BoxDecoration(
              color: isSelected ? const Color(0XFFFFF3E5) : Colors.white,
              borderRadius: const BorderRadius.all(Radius.circular(10)),
              border: isSelected
                  ? Border.all(width: 3, color: Theme.of(context).primaryColor)
                  : Border.all(width: 3, color: Colors.transparent),
              boxShadow: [
                const BoxShadow(
                  color: Color.fromRGBO(0, 0, 0, 0.16),
                  offset: Offset(0, 8),
                  blurRadius: 6,
                ),
              ],
            ),
            child: Column(
              children: [
                Container(height: 18),
                Expanded(
                  flex: 5,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 4),
                        child: Icon(
                          icon,
                          size: 48.0,
                          color: isSelected
                              ? Theme.of(context).primaryColor
                              : CustomColors.black1,
                        ),
                      ),
                      Center(
                        child: Text(
                          '${cause.title}',
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium!
                              .copyWith(
                                fontSize: 18.0,
                              ),
                          textScaler: const TextScaler.linear(.6),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    MaterialButton(
                      child: const Text(
                        'Learn more',
                        textAlign: TextAlign.center,
                      ),
                      onPressed: () => openInfoDialog(context),
                      padding: const EdgeInsets.symmetric(horizontal: 0),
                    ),
                    IconButton(
                      icon:
                          const Icon(FontAwesomeIcons.circleQuestion, size: 14),
                      onPressed: () => openInfoDialog(context),
                    ),
                  ],
                ),
                const SizedBox(height: 1),
              ],
            ),
          );
        },
      ),
    );
  }
}
