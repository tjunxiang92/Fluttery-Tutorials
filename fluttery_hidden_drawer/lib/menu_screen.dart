import 'package:flutter/material.dart';
import 'package:fluttery_hidden_drawer/zoom_scaffold.dart';

final menuScreenKey = new GlobalKey(debugLabel: 'MenuScreen');

class MenuScreen extends StatefulWidget {
  final Menu menu;
  final String selectedItemId;
  final Function(String) onMenuItemSelected;

  MenuScreen({
    this.menu,
    this.selectedItemId,
    this.onMenuItemSelected,
  }) : super(key: menuScreenKey);

  @override
  _MenuScreenState createState() => new _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> with TickerProviderStateMixin {
  
  AnimationController titleAnimationController;
  double selectorYTop;
  double selectorYBottom;

  setSelectedRenderBox(RenderBox renderBox) async {
    final newYTop = renderBox.localToGlobal(const Offset(0.0, 0.0)).dy;    
    final newYBottom = newYTop + renderBox.size.height;    
    if (selectorYTop != newYTop) {
      setState(() {
        selectorYTop = newYTop;
        selectorYBottom = newYBottom;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    titleAnimationController = new AnimationController(
      duration: new Duration(milliseconds: 250),
      vsync: this,
    );
  }

  @override
  void dispose() {
    titleAnimationController.dispose();
    super.dispose();
  }

  createMenuTitle(MenuController menuController) {
    switch (menuController.state) {
      case MenuState.open:
      case MenuState.opening:
        titleAnimationController.forward();
        break;
      case MenuState.closed:
      case MenuState.closing:
        titleAnimationController.reverse();
        break;
    }

    return new AnimatedBuilder(
      animation: titleAnimationController,
      child: new OverflowBox(
        maxWidth: double.infinity,
        alignment: Alignment.topLeft,
        child: new Padding(
          padding: const EdgeInsets.all(30.0),
          child: new Text(
            'Menu',
            style: new TextStyle(
              color: const Color(0x88444444),
              fontSize: 240.0,
              fontFamily: 'mermaid',
            ),
            textAlign: TextAlign.left,
            softWrap: false,
          ),
        ),
      ),
      builder: (BuildContext context, Widget child) {
        return new Transform(
          transform: new Matrix4.translationValues(
            250.0 * (1.0 - titleAnimationController.value) - 100.0,
            0.0, 
            0.0
          ),
          child: child,
        );
      },
    );
  }

  createMenuItems(MenuController menuController) {
    final List<Widget> listItems = [];
    final animationIntervalDuration = 0.5;
    final perListItemDelay = menuController.state != MenuState.closing ? 0.15 : 0.0;
    for (var i = 0; i < widget.menu.items.length; i++) {
      final animationIntervalStart = perListItemDelay * i;
      final animationIntervalEnd = animationIntervalDuration + animationIntervalStart;
      final isSelected = widget.menu.items[i].id == widget.selectedItemId;
      listItems.add(
        new AnimatedMenuListItem(
          menuState: menuController.state,
          duration: new Duration(milliseconds: 600),
          isSelected: isSelected,
          curve: new Interval(animationIntervalStart, animationIntervalEnd, curve: Curves.easeOut),
          menuListItem: new _MenuListItem(
            title: widget.menu.items[i].title,
              isSelected: isSelected,
            onTap: () {
              widget.onMenuItemSelected(widget.menu.items[i].id);
              menuController.close();
            },
          ),
        ),
      );
    }

    return new Transform(
      transform: new Matrix4.translationValues(0.0, 225.0, 0.0),
      child: new Column(
        children: listItems,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // print("RenderBox Y Pos: $selectorYTop");

    return new ZoomScaffoldMenuController(
      builder: (BuildContext context, MenuController menuController) {
        var shouldRenderSelector = true;
        var actualSelectorYTop = selectorYTop;
        var actualSelectorYBottom = selectorYBottom;
        var selectorOpacity = 1.0;

        if (menuController.state == MenuState.closed ||
          menuController.state == MenuState.closing ||
          selectorYTop == null) {
            final RenderBox menuRB = context.findRenderObject() as RenderBox;
            if (menuRB == null) {
              shouldRenderSelector = false;
            } else {
              final menuScreenHeight = menuRB.size.height;
              actualSelectorYTop = menuScreenHeight - 50.0;
              actualSelectorYBottom = menuScreenHeight;
              selectorOpacity = 0.0;
            }
        }


        return new Container(
          width: double.infinity,
          height: double.infinity,
          decoration: new BoxDecoration(
            image: new DecorationImage(
              image: new AssetImage('assets/dark_grunge_bk.jpg'),
              fit: BoxFit.cover,
            )
          ),
          child: new Material(
            color: Colors.transparent,
            child: new Stack(
              children: <Widget>[
                createMenuTitle(menuController),
                createMenuItems(menuController),
                shouldRenderSelector
                  ? new ItemSelector(
                      topY: actualSelectorYTop,
                      bottomY: actualSelectorYBottom,
                      opacity: 1.0,
                    )
                  : new Container(),
              ],
            ),
          ),
        );
      },
    );
  }
}

class ItemSelector extends ImplicitlyAnimatedWidget {
  final topY;
  final bottomY;
  final opacity;

  ItemSelector({
    this.topY,
    this.bottomY,
    this.opacity,
  }) : super(duration: const Duration(milliseconds: 250));

  @override
  _ItemSelectorState createState() => new _ItemSelectorState();
}

class _ItemSelectorState extends AnimatedWidgetBaseState<ItemSelector> {
  Tween<double> _topY;
  Tween<double> _bottomY;
  Tween<double> _opacity;

  @override
  void forEachTween(TweenVisitor visitor) {
    _topY = visitor(
      _topY,
      widget.topY,
      (dynamic value) => new Tween<double>(begin: value)
    );

    _bottomY = visitor(
      _bottomY,
      widget.bottomY,
      (dynamic value) => new Tween<double>(begin: value)
    );

    _opacity = visitor(
      _opacity,
      widget.opacity,
      (dynamic value) => new Tween<double>(begin: value)
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Positioned(
      top: _topY.evaluate(animation),
      child: new Opacity(
        opacity: _opacity.evaluate(animation),
        child: new Container(
          width: 5.0,
          height: _bottomY.evaluate(animation) - _topY.evaluate(animation),
          color: Colors.red,
        ),
      ),
    );
  }
}

class AnimatedMenuListItem extends ImplicitlyAnimatedWidget {
  final _MenuListItem menuListItem;
  final MenuState menuState;
  final bool isSelected;
  final Duration duration;

  AnimatedMenuListItem({
    this.menuListItem,
    this.menuState,
    this.isSelected,
    this.duration,
    curve,
  }) : super(duration: duration, curve: curve);

  @override
  _AnimatedMenuListItemState createState() => new _AnimatedMenuListItemState();
}

class _AnimatedMenuListItemState extends AnimatedWidgetBaseState<AnimatedMenuListItem> {

  final double closedPosition = 200.0;
  final double openPosition = 0.0;

  Tween<double> _translation;
  Tween<double> _opacity;
  
  updateSelectedRenderBox() {
    final renderBox = context.findRenderObject() as RenderBox;
    if (renderBox != null && widget.isSelected) {
      // print("Size ${renderBox.size} ${renderBox.localToGlobal(const Offset(0.0, 0.0))}");
      (menuScreenKey.currentState as _MenuScreenState).setSelectedRenderBox(renderBox);
    }
  }

  @override
  void forEachTween(TweenVisitor visitor) {
    var slide, opacity;

    switch (widget.menuState) {
      case MenuState.closed:
      case MenuState.closing:
        slide = closedPosition;
        opacity = 0.0;
        break;
      case MenuState.open:
      case MenuState.opening:
        slide = openPosition;
        opacity = 1.0;
        break;
    }

    _translation = visitor(
      _translation,
      slide,
      (dynamic value) => new Tween<double>(begin: value),
    );

    _opacity = visitor(
      _opacity,
      opacity,
      (dynamic value) => new Tween<double>(begin: value),
    );
  }
  
  @override
  Widget build(BuildContext context) {
    updateSelectedRenderBox();

    return new Opacity(
      opacity: _opacity.evaluate(animation),
      child: new Transform(
        transform: new Matrix4.translationValues(
          0.0, 
          _translation.evaluate(animation), 
          0.0
        ),
        child: widget.menuListItem,
      ),
    );
  }
}

class _MenuListItem extends StatelessWidget {
  final String title;
  final bool isSelected;
  final Function onTap;

  _MenuListItem({
    this.title,
    this.isSelected,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return new InkWell(
      splashColor: const Color(0x44000000),
      onTap: isSelected ? null : onTap,
      child: new Container(
        width: double.infinity,
        child: new Padding(
          padding: const EdgeInsets.only(left: 50.0, top: 15.0, bottom: 15.0),
          child: new Text(
            title,
            style: new TextStyle(
              color: isSelected ? Colors.red : Colors.white,
              fontSize: 25.0,
              fontFamily: 'bebas-neue',
              letterSpacing: 2.0,
            ),
          ),
        ),
      ),
    );
  }
}

class Menu {
  final List<MenuItems> items;

  Menu({
    this.items,
  });
}

class MenuItems {
  final String id;
  final String title;

  MenuItems({
    this.id,
    this.title,
  });
}