import 'package:flutter/material.dart';

/// Accessible Widget: widget with capability to check required permissions
class AccessibleBuilder extends StatefulWidget {
  /// Construct and supply params
  const AccessibleBuilder({
    required this.permissionToCheck,
    required this.builder,
    required this.onPermissionChecked,
    required this.widgetPermissions,
    this.triggerCheckedOnInit = false,
    this.autoCheck = false,
    super.key,
  });

  /// List of permission to check
  final List<String> permissionToCheck;

  /// Widget builder
  final Widget Function(
    BuildContext context,
    void Function() check, {
    required bool isAllowed,
  }) builder;

  /// Triggered when permission checked
  final ValueChanged<bool> onPermissionChecked;

  /// Check on init when its true
  final bool autoCheck;

  /// Widget permissions
  final List<String> widgetPermissions;

  /// Trigger checked on init, only available on autoCheck true
  final bool triggerCheckedOnInit;

  @override
  State<AccessibleBuilder> createState() => _AccessibleBuilderState();
}

class _AccessibleBuilderState extends State<AccessibleBuilder> {
  @override
  void initState() {
    if (widget.autoCheck) {
      _allowed = _checkAccesses(widget.permissionToCheck);
      if (widget.triggerCheckedOnInit) {
        widget.onPermissionChecked(_allowed);
      }
    }

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    assert(
      widget.permissionToCheck.isNotEmpty,
      'Permission to check could not be empty',
    );
    assert(
      widget.widgetPermissions.isNotEmpty,
      'Widget permission could not be empty',
    );
    return widget.builder(
      context,
      _check,
      isAllowed: _allowed,
    );
  }

  void _check() {
    _allowed = _checkAccesses(permissions);
    widget.onPermissionChecked(_allowed);
    setState(() {});
  }

  bool _checkAccesses(List<String> perms) {
    final x = <bool>[];
    for (final e in perms) {
      if (permissions.contains(e)) {
        x.add(true);
      } else {
        x.add(false);
      }
    }
    return x.contains(true);
  }

  bool _allowed = true;

  List<String> get permissions => widget.widgetPermissions;
}
