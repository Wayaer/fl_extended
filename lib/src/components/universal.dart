import 'dart:ui';

import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 通用布局容器：按需组合对齐、约束、滚动、手势等常用能力。
class Universal extends StatelessWidget {
  const Universal({
    super.key,
    this.systemOverlayStyle,
    this.sized = true,
    this.dragStartBehavior = DragStartBehavior.start,
    this.intrinsicHeight = false,
    this.intrinsicWidth = false,
    this.stepWidth,
    this.stepHeight,
    this.clipBehavior,
    this.alignment,
    this.widthFactor,
    this.heightFactor,
    this.borderRadius,
    this.child,
    this.children,
    this.isWrap = false,
    this.wrapAlignment = WrapAlignment.start,
    this.spacing = 0.0,
    this.runAlignment = WrapAlignment.start,
    this.runSpacing = 0.0,
    this.wrapCrossAxisAlignment = WrapCrossAlignment.start,
    this.flex = 1,
    this.expanded = false,
    this.flexible = false,
    this.constraints,
    this.color,
    this.margin,
    this.padding,
    this.decoration,
    this.decorationPosition = DecorationPosition.background,
    this.left,
    this.top,
    this.right,
    this.bottom,
    this.mainAxisAlignment = MainAxisAlignment.start,
    this.crossAxisAlignment = CrossAxisAlignment.center,
    this.direction = Axis.vertical,
    this.textBaseline,
    this.verticalDirection = VerticalDirection.down,
    this.textDirection,
    this.mainAxisSize = MainAxisSize.max,
    this.clipper,
    this.isOval = false,
    this.isClipRRect = false,
    this.isClipRect = false,
    this.isClipPath = false,
    this.isScroll = false,
    this.noScrollBehavior = true,
    this.physics,
    this.scrollController,
    this.scrollDirection,
    this.reverse = false,
    this.primary,
    this.keyboardDismissBehavior = ScrollViewKeyboardDismissBehavior.manual,
    this.restorationId,
    this.expand = false,
    this.size,
    this.width,
    this.height,
    this.aspectRatio,
    this.opacity,
    this.heroTag,
    this.createRectTween,
    this.flightShuttleBuilder,
    this.transitionOnUserGestures = false,
    this.placeholderBuilder,
    this.isStack = false,
    this.stackFit = StackFit.loose,
    this.stackAlignment = AlignmentDirectional.topStart,
    this.safeLeft = false,
    this.safeTop = false,
    this.safeRight = false,
    this.safeBottom = false,
    this.safeLTRB = false,
    this.onPressed,
    this.buttonCategory,
    this.onHover,
    this.onFocusChange,
    this.style,
    this.focusNode,
    this.autofocus = false,
    this.statesController,
    this.onTap,
    this.onTapUp,
    this.onDoubleTap,
    this.onDoubleTapDown,
    this.onDoubleTapCancel,
    this.onLongPress,
    this.onTapDown,
    this.onTapCancel,
    this.excludeFromSemantics = false,
    this.onSecondaryTapDown,
    this.onSecondaryTapUp,
    this.onSecondaryTapCancel,
    this.onSecondaryTap,
    this.onLongPressStart,
    this.onLongPressMoveUpdate,
    this.onLongPressUp,
    this.onLongPressEnd,
    this.onLongPressCancel,
    this.onLongPressDown,
    this.onVerticalDragDown,
    this.onVerticalDragStart,
    this.onVerticalDragUpdate,
    this.onVerticalDragEnd,
    this.onVerticalDragCancel,
    this.onHorizontalDragDown,
    this.onHorizontalDragStart,
    this.onHorizontalDragUpdate,
    this.onHorizontalDragEnd,
    this.onHorizontalDragCancel,
    this.onPanDown,
    this.onPanStart,
    this.onPanUpdate,
    this.onPanEnd,
    this.onPanCancel,
    this.onScaleStart,
    this.onScaleUpdate,
    this.onScaleEnd,
    this.onForcePressStart,
    this.onForcePressPeak,
    this.onForcePressUpdate,
    this.onForcePressEnd,
    this.onTertiaryLongPress,
    this.onTertiaryLongPressCancel,
    this.onTertiaryLongPressDown,
    this.onTertiaryLongPressEnd,
    this.onTertiaryLongPressMoveUpdate,
    this.onTertiaryLongPressStart,
    this.onTertiaryLongPressUp,
    this.onTertiaryTapCancel,
    this.onTertiaryTapDown,
    this.onTertiaryTapUp,
    this.onSecondaryLongPressMoveUpdate,
    this.onSecondaryLongPressUp,
    this.onSecondaryLongPress,
    this.onSecondaryLongPressEnd,
    this.onSecondaryLongPressStart,
    this.onSecondaryLongPressCancel,
    this.onSecondaryLongPressDown,
    this.supportedDevices,
    this.trackpadScrollCausesScale = false,
    this.trackpadScrollToScaleFactor = kDefaultTrackpadScrollToScaleFactor,
    this.behavior = HitTestBehavior.opaque,
  }) : assert(!(isStack && isWrap), "isStack and isWrap cannot be true at the same time (conflicting layout types)."),
       assert(
         !(expanded && flexible),
         "expanded and flexible cannot be true at the same time (conflicting Flex widgets).",
       ),
       assert(
         !safeLTRB || !(safeLeft || safeTop || safeRight || safeBottom),
         "safeLeft, safeTop, safeRight, safeBottom must be false when safeLTRB is true (safeLTRB enables all).",
       );

  /// 系统状态栏/导航栏样式（[AnnotatedRegion]）
  final SystemUiOverlayStyle? systemOverlayStyle;

  /// [AnnotatedRegion] 是否贴合子组件尺寸
  final bool sized;

  /// [GestureDetector]、[SingleChildScrollView] 相关配置：拖拽行为配置
  /// 拖拽开始时的行为策略，影响拖拽起点的计算方式
  /// - [DragStartBehavior.start]：以手势被识别时的位置作为拖拽起点（默认值）
  /// - [DragStartBehavior.down]：以手指按下的位置作为拖拽起点
  final DragStartBehavior dragStartBehavior;

  /// [IntrinsicHeight]、[IntrinsicWidth] 相关配置：自适应尺寸配置
  /// 是否启用 [IntrinsicHeight]：让组件高度自适应子组件的最大高度
  final bool intrinsicHeight;

  /// 是否启用 [IntrinsicWidth]：让组件宽度自适应子组件的最大宽度
  final bool intrinsicWidth;

  /// [IntrinsicWidth] 宽度向上对齐到该步长的整数倍（需 [intrinsicWidth]）
  final double? stepWidth;

  /// [IntrinsicWidth] 高度向上对齐到该步长的整数倍（需 [intrinsicWidth]）
  final double? stepHeight;

  /// [Stack]、[ClipRRect]、[ClipPath]、[ClipRect]、[ClipOval]、[Flex]、[SingleChildScrollView] 相关配置：剪辑行为配置
  /// 控制组件的内容剪辑方式，平衡「视觉效果」与「性能」
  /// - [Clip.none]：不剪辑（最快，适合无溢出场景）
  /// - [Clip.hardEdge]：剪辑但不抗锯齿（较快，适合对边缘平滑度要求低的场景）
  /// - [Clip.antiAlias]：剪辑且抗锯齿（较慢，适合需要平滑边缘的场景，如圆角图片）
  /// - [Clip.antiAliasWithSaveLayer]：抗锯齿+额外图层（最慢，仅在复杂剪辑时使用）
  /// 生效组件：[Stack]（子组件溢出时）、[ClipRRect]、[ClipPath]、[ClipRect]、[ClipOval]、[Flex]、[SingleChildScrollView]
  final Clip? clipBehavior;

  /// [Align] 相关配置：子组件对齐配置
  /// 子组件在父组件中的对齐方式（如 [Alignment.center]、[Alignment.topLeft]）
  /// 仅当组件包裹 [Align] 时生效，用于精确控制子组件位置
  final AlignmentGeometry? alignment;

  /// 父宽相对子宽的倍数；设置后会自动包裹 [Align]（[alignment] 默认居中）
  final double? widthFactor;

  /// 父高相对子高的倍数；设置后会自动包裹 [Align]（[alignment] 默认居中）
  final double? heightFactor;

  /// [ClipRRect] 圆角（需 [isClipRRect]）
  final BorderRadius? borderRadius;

  /// 单/多子组件通用配置：子组件容器配置
  /// 单个子组件（适用于 [SingleChildScrollView]、[Align]、[Opacity] 等单子组件）
  final Widget? child;

  /// 多子节点；与 [child] 同时存在时 [child] 会并入列表首位
  final List<Widget>? children;

  /// true 用 [Wrap]，false 用 [Flex]（与 [isStack] 互斥）
  final bool isWrap;

  /// [Wrap] 主轴方向的子组件对齐方式（如 [WrapAlignment.start]、[WrapAlignment.spaceBetween]）
  /// 仅当 isWrap 为 true 时生效，控制一行内子组件的分布
  final WrapAlignment wrapAlignment;

  /// [Wrap] 主轴方向上子组件之间的间距（如横向 Wrap 时的左右间距）
  final double spacing;

  /// [Wrap] 交叉轴方向的行/列对齐方式（如纵向 Wrap 时的行对齐）
  final WrapAlignment runAlignment;

  /// [Wrap] 交叉轴方向上行/列之间的间距（如横向 Wrap 时的上下行间距）
  final double runSpacing;

  /// [Wrap] 交叉轴方向上子组件的对齐方式（如 [WrapCrossAlignment.center]）
  final WrapCrossAlignment wrapCrossAxisAlignment;

  /// [Flexible]、[Expanded] 相关配置：弹性布局配置
  /// 弹性系数（决定组件在主轴方向上的占比，如 flex:2 的组件占比是 flex:1 的2倍）
  final int flex;

  /// 启用 [Expanded]（与 [flexible] 互斥）
  final bool expanded;

  /// 启用 [Flexible]（与 [expanded] 互斥）
  final bool flexible;

  /// [ConstrainedBox] 相关配置：尺寸约束配置
  /// 给组件添加额外的尺寸约束（如最小宽高、最大宽高，例：BoxConstraints(minHeight: 50)）
  /// 用于限制组件的尺寸范围，优先级高于父组件的默认约束
  final BoxConstraints? constraints;

  /// 纯色背景；有 [decoration] 时由其 color 优先
  final Color? color;

  /// 组件的外部间距（与父组件或其他兄弟组件的距离）
  final EdgeInsetsGeometry? margin;

  /// 组件的内部间距（与子组件的距离）
  final EdgeInsetsGeometry? padding;

  /// 装饰；优先级高于 [color]
  final BoxDecoration? decoration;

  /// 装饰的绘制位置（相对于子组件）
  /// - [DecorationPosition.background]：装饰在子组件下方（背景）
  /// - [DecorationPosition.foreground]：装饰在子组件上方（前景，会覆盖子组件）
  final DecorationPosition decorationPosition;

  /// [Stack] 内 [Positioned] 左边距（与 expanded/flexible 互斥）
  final double? left;

  /// 子组件相对于 [Stack] 顶部的距离
  final double? top;

  /// 子组件相对于 [Stack] 右侧的距离
  final double? right;

  /// 子组件相对于 [Stack] 底部的距离
  final double? bottom;

  /// [Flex]、[Row]、[Column] 相关配置：线性布局配置
  /// 主轴方向的对齐方式（如 [MainAxisAlignment.center]、[MainAxisAlignment.spaceAround]）
  final MainAxisAlignment mainAxisAlignment;

  /// 交叉轴方向的对齐方式（如 [CrossAxisAlignment.baseline]、[CrossAxisAlignment.stretch]）
  final CrossAxisAlignment crossAxisAlignment;

  /// 主轴方向（[Axis.horizontal] = Row 横向；[Axis.vertical] = Column 纵向）
  final Axis direction;

  /// 仅 [CrossAxisAlignment.baseline] 时生效
  final TextBaseline? textBaseline;

  /// 垂直方向的布局顺序（仅在 direction 为 [Axis.vertical] 时生效）
  /// - [VerticalDirection.down]：从上到下；[VerticalDirection.up]：从下到上
  final VerticalDirection verticalDirection;

  /// 文本方向（影响主轴对齐的起始方向，如 [TextDirection.ltr] 从左到右）
  final TextDirection? textDirection;

  /// 主轴方向的尺寸模式（[MainAxisSize.max] 占满父组件；[MainAxisSize.min] 适应子组件）
  final MainAxisSize mainAxisSize;

  /// 自定义剪辑器；须与对应 isClip* 类型匹配
  final CustomClipper<dynamic>? clipper;

  /// 剪辑开关互斥，至多开启一个
  final bool isOval;

  /// 是否启用 [ClipRRect]：将组件剪辑为圆角矩形（需配合 [borderRadius] 设置圆角）
  final bool isClipRRect;

  /// 是否启用 [ClipRect]：将组件剪辑为矩形（仅裁剪溢出部分，无圆角）
  final bool isClipRect;

  /// 是否启用 [ClipPath]：按自定义路径剪辑（需配合 clipper 设置路径）
  final bool isClipPath;

  /// [SingleChildScrollView] 相关配置：滚动配置
  /// 是否启用滚动（true：用 [SingleChildScrollView] 包裹；false：禁用滚动）
  final bool isScroll;

  /// 移除滚动边缘发光
  final bool noScrollBehavior;

  /// 滚动的物理效果（如 [AlwaysScrollableScrollPhysics] 始终可滚动，[NeverScrollableScrollPhysics] 禁止滚动）
  final ScrollPhysics? physics;

  /// 滚动控制器（用于控制滚动位置、监听滚动事件，如 scrollController.jumpTo(0) 回到顶部）
  final ScrollController? scrollController;

  /// 未设时回退为 [direction]
  final Axis? scrollDirection;

  /// 是否反向滚动（true：滚动方向反转，如纵向时从下往上滚）
  final bool reverse;

  /// 是否作为父级滚动视图的主要子组件（true：继承父级滚动控制器；false：使用自身 scrollController）
  final bool? primary;

  /// 滚动时键盘的关闭策略（如 [ScrollViewKeyboardDismissBehavior.onDrag] 拖拽时关闭键盘）
  final ScrollViewKeyboardDismissBehavior keyboardDismissBehavior;

  /// 滚动状态恢复ID（用于保存/恢复滚动位置，如页面重建后恢复之前的滚动位置）
  final String? restorationId;

  /// 尺寸控制互斥：expand / width·height / size / aspectRatio 至多其一。
  /// 同时设置多个时仅 debug 会触发断言；release 下按
  /// `expand > width/height > size > aspectRatio` 的优先级取第一个。
  final bool expand;

  /// 组件的固定尺寸（同时设置宽高，优先级低于 expand，高于单独的 width/height）
  final Size? size;

  /// 组件的固定宽度（优先级低于 size 和 expand）
  final double? width;

  /// 组件的固定高度（优先级低于 size 和 expand）
  final double? height;

  /// [AspectRatio] 相关配置：固定宽高比配置
  /// 组件的宽高比（如 16/9、1/1，计算方式：宽 = 高 × aspectRatio）
  /// 用于强制组件按固定比例显示（如视频播放器、图片容器）
  final double? aspectRatio;

  /// [Opacity] 相关配置：透明度配置
  /// 组件的透明度（0.0 完全透明；1.0 不透明）
  /// 会影响所有子组件的透明度
  final double? opacity;

  /// 非 null 时启用 [Hero]；跨路由须相同
  final Object? heroTag;

  /// 定义 Hero 过渡动画的「矩形变化规则」（自定义过渡路径）
  /// 默认使用 [RectTween]（线性矩形过渡），可自定义实现特殊效果（如缩放+平移、曲线过渡）
  final CreateRectTween? createRectTween;

  /// 自定义 Hero 过渡过程中的「穿梭组件」（过渡中显示的临时组件）
  /// 替换默认的过渡组件，可添加个性化内容（如过渡时显示“加载中”文字、进度条）
  final HeroFlightShuttleBuilder? flightShuttleBuilder;

  /// 是否在「用户手势导航」时触发 Hero 过渡（如侧滑返回、底部上滑返回）
  /// true：手势导航与 Hero 动画同步；false：仅通过 [Navigator.push/pop] 代码跳转时触发
  final bool transitionOnUserGestures;

  /// Hero 组件离开当前页面后，当前页面留下的「占位组件」
  /// 避免 Hero 离开后出现空白，默认显示与 Hero 尺寸相同的透明容器，可自定义占位样式（如灰色骨架屏）
  final HeroPlaceholderBuilder? placeholderBuilder;

  /// 启用 [Stack]（与 [isWrap] 互斥）
  final bool isStack;

  /// Stack 子组件的「尺寸适应规则」（控制子组件如何填充 Stack 空间）
  /// - [StackFit.loose]：子组件按自身尺寸显示（默认，如小图标在 Stack 中保持原大小）
  /// - [StackFit.expand]：子组件强制占满 Stack 可用空间（如背景图铺满 Stack）
  /// - [StackFit.passthrough]：子组件尺寸跟随父组件约束，不额外调整（如继承父组件的宽高限制）
  final StackFit stackFit;

  /// Stack 中「未定位子组件」的默认对齐方式（定位子组件需用 [Positioned] 单独控制）
  /// 默认值为 [AlignmentDirectional.topStart]，适配不同文本方向（LTR 从左上、RTL 从右上）
  final AlignmentGeometry stackAlignment;

  /// [SafeArea] 相关配置：安全区域配置（避开系统遮挡区域）
  /// 是否避开「左侧安全区域」（如刘海屏左侧、平板侧边系统栏、折叠屏左侧缝隙）
  final bool safeLeft;

  /// 是否避开「顶部安全区域」（如刘海屏、水滴屏、状态栏）
  final bool safeTop;

  /// 是否避开「右侧安全区域」（如刘海屏右侧、平板侧边系统栏、折叠屏右侧缝隙）
  final bool safeRight;

  /// 是否避开「底部安全区域」（如手机底部导航栏、全面屏手势区域）
  final bool safeBottom;

  /// 四边 SafeArea 全开；为 true 时单边 safe* 须为 false
  final bool safeLTRB;

  /// [FlButton] 点击；[buttonCategory] 非 null 时走按钮体系
  final VoidCallback? onPressed;

  /// 非 null 用 [FlButton]，null 且有手势回调时用 [GestureDetector]
  final FlButtonCategory? buttonCategory;

  /// 鼠标悬浮状态变化时的回调，参数为「是否悬浮」（true=悬浮，false=离开）
  /// 仅支持鼠标设备，常用于按钮悬浮时的样式反馈
  final ValueChanged<bool>? onHover;

  /// 按钮焦点状态变化时的回调，参数为「是否获取焦点」
  /// 用于键盘导航场景，配合 [focusNode] 管理焦点
  final ValueChanged<bool>? onFocusChange;

  /// FlButton 的样式配置，可覆盖默认分类样式
  /// 优先级高于 [buttonCategory] 自带样式
  final ButtonStyle? style;

  /// 管理按钮的焦点节点，用于手动控制焦点获取/失去
  /// 若为 null，会自动创建临时焦点节点
  final FocusNode? focusNode;

  /// 是否在组件挂载时自动获取焦点，默认值为 false
  final bool autofocus;

  /// 手动管理 FlButton 的状态，默认值为 null
  /// 用于自定义状态切换逻辑，优先级高于组件内部状态
  final WidgetStatesController? statesController;

  /// 普通点击完成时触发（手指按下后抬起的完整流程）
  /// 常用于非按钮组件的点击交互
  final GestureTapCallback? onTap;

  /// 点击过程中手指抬起瞬间触发，可获取抬起位置、设备信息
  final GestureTapUpCallback? onTapUp;

  /// 短时间内完成两次点击（双击）时触发
  final GestureTapCallback? onDoubleTap;

  /// 双击过程中「第二次点击」按下时触发
  final GestureTapDownCallback? onDoubleTapDown;

  /// 双击动作被中断时触发
  final GestureTapCancelCallback? onDoubleTapCancel;

  /// 手指长按屏幕超过 500ms 且未移动时触发
  final GestureLongPressCallback? onLongPress;

  /// 点击过程中手指刚按下时触发，可获取按下位置、设备信息
  final GestureTapDownCallback? onTapDown;

  /// 点击动作被中断时触发
  final GestureTapCancelCallback? onTapCancel;

  /// 是否将当前组件排除在语义树之外（无障碍功能相关），默认值为 false
  final bool excludeFromSemantics;

  /// 次要触摸（如鼠标右键）按下时触发
  final GestureTapDownCallback? onSecondaryTapDown;

  /// 次要触摸（如鼠标右键）抬起时触发
  final GestureTapUpCallback? onSecondaryTapUp;

  /// 次要触摸（如鼠标右键）动作被中断时触发
  final GestureTapCancelCallback? onSecondaryTapCancel;

  /// 次要触摸（如鼠标右键）的完整点击回调
  final GestureTapCallback? onSecondaryTap;

  /// 长按开始时触发（刚达到 500ms 阈值瞬间）
  final GestureLongPressStartCallback? onLongPressStart;

  /// 长按过程中手指移动时持续触发
  final GestureLongPressMoveUpdateCallback? onLongPressMoveUpdate;

  /// 长按过程中手指抬起时触发
  final GestureLongPressUpCallback? onLongPressUp;

  /// 长按动作结束时触发（包含抬起或取消的最终状态）
  final GestureLongPressEndCallback? onLongPressEnd;

  /// 长按动作被系统取消时触发
  final GestureLongPressCancelCallback? onLongPressCancel;

  /// 长按按下阶段触发（未达到 500ms 阈值时）
  final GestureLongPressDownCallback? onLongPressDown;

  /// 触摸点开始交互且有垂直移动趋势时触发
  final GestureDragDownCallback? onVerticalDragDown;

  /// 触摸点开始在垂直方向上移动时触发
  final GestureDragStartCallback? onVerticalDragStart;

  /// 垂直拖拽过程中位置变化时持续触发
  final GestureDragUpdateCallback? onVerticalDragUpdate;

  /// 垂直拖拽结束时触发（手指抬起）
  final GestureDragEndCallback? onVerticalDragEnd;

  /// 垂直拖拽动作被中断时触发
  final GestureDragCancelCallback? onVerticalDragCancel;

  /// 触摸点开始交互且有水平移动趋势时触发
  final GestureDragDownCallback? onHorizontalDragDown;

  /// 触摸点开始在水平方向上移动时触发
  final GestureDragStartCallback? onHorizontalDragStart;

  /// 水平拖拽过程中位置变化时持续触发
  final GestureDragUpdateCallback? onHorizontalDragUpdate;

  /// 水平拖拽结束时触发
  final GestureDragEndCallback? onHorizontalDragEnd;

  /// 水平拖拽动作未正常完成时触发
  final GestureDragCancelCallback? onHorizontalDragCancel;

  /// 触摸点开始与屏幕交互时触发（平移准备阶段）
  final GestureDragDownCallback? onPanDown;

  /// 触摸点开始在任意方向移动时触发
  final GestureDragStartCallback? onPanStart;

  /// 平移过程中位置变化时持续触发
  final GestureDragUpdateCallback? onPanUpdate;

  /// 平移动作完成时触发
  final GestureDragEndCallback? onPanEnd;

  /// 平移动作被中断时触发
  final GestureDragCancelCallback? onPanCancel;

  /// 缩放手势开始时触发（如双指接触屏幕）
  final GestureScaleStartCallback? onScaleStart;

  /// 缩放过程中持续触发（双指距离变化时）
  final GestureScaleUpdateCallback? onScaleUpdate;

  /// 缩放手势结束时触发（双指离开屏幕）
  final GestureScaleEndCallback? onScaleEnd;

  /// 压力触摸开始时触发（压力超过阈值）
  final GestureForcePressStartCallback? onForcePressStart;

  /// 压力触摸达到最大压力时触发
  final GestureForcePressPeakCallback? onForcePressPeak;

  /// 压力触摸过程中压力变化时持续触发
  final GestureForcePressUpdateCallback? onForcePressUpdate;

  /// 压力触摸结束时触发（压力回到阈值以下）
  final GestureForcePressEndCallback? onForcePressEnd;

  /// 第三触摸点长按完成时触发
  final GestureLongPressCallback? onTertiaryLongPress;

  /// 第三触摸点长按被取消时触发
  final GestureLongPressCancelCallback? onTertiaryLongPressCancel;

  /// 第三触摸点长按按下阶段触发
  final GestureLongPressDownCallback? onTertiaryLongPressDown;

  /// 第三触摸点长按结束时触发
  final GestureLongPressEndCallback? onTertiaryLongPressEnd;

  /// 第三触摸点长按过程中移动时触发
  final GestureLongPressMoveUpdateCallback? onTertiaryLongPressMoveUpdate;

  /// 第三触摸点长按开始时触发
  final GestureLongPressStartCallback? onTertiaryLongPressStart;

  /// 第三触摸点长按抬起时触发
  final GestureLongPressUpCallback? onTertiaryLongPressUp;

  /// 第三触摸点点击被取消时触发
  final GestureTapCancelCallback? onTertiaryTapCancel;

  /// 第三触摸点点击按下时触发
  final GestureTapDownCallback? onTertiaryTapDown;

  /// 第三触摸点点击抬起时触发
  final GestureTapUpCallback? onTertiaryTapUp;

  /// 次要触摸长按过程中移动时触发
  final GestureLongPressMoveUpdateCallback? onSecondaryLongPressMoveUpdate;

  /// 次要触摸长按抬起时触发
  final GestureLongPressCallback? onSecondaryLongPressUp;

  /// 次要触摸长按完成时触发
  final GestureLongPressCallback? onSecondaryLongPress;

  /// 次要触摸长按结束时触发
  final GestureLongPressEndCallback? onSecondaryLongPressEnd;

  /// 次要触摸长按开始时触发
  final GestureLongPressStartCallback? onSecondaryLongPressStart;

  /// 次要触摸长按被取消时触发
  final GestureLongPressCancelCallback? onSecondaryLongPressCancel;

  /// 次要触摸长按按下阶段触发
  final GestureLongPressDownCallback? onSecondaryLongPressDown;

  /// 支持的输入设备类型集合（如仅响应触摸/鼠标）
  final Set<PointerDeviceKind>? supportedDevices;

  /// 是否将触控板滚动事件转换为缩放手势，默认值为 false
  final bool trackpadScrollCausesScale;

  /// 触控板滚动与缩放因子的转换比例，默认值为 (0.01, 0.01)
  final Offset trackpadScrollToScaleFactor;

  /// 事件命中测试行为：
  /// - HitTestBehavior.opaque：当前组件处理事件，不向下传递
  /// - HitTestBehavior.deferToChild：由子组件处理事件
  /// - HitTestBehavior.translucent：当前组件和子组件均可接收事件
  final HitTestBehavior behavior;

  EdgeInsetsGeometry? get _paddingIncludingDecoration {
    return switch ((padding, decoration?.padding)) {
      (null, final EdgeInsetsGeometry? padding) => padding,
      (final EdgeInsetsGeometry? padding, null) => padding,
      (_) => padding!.add(decoration!.padding),
    };
  }

  @override
  Widget build(BuildContext context) {
    Widget current = const SizedBox.shrink();
    if (children != null && children!.isNotEmpty) {
      final List<Widget> resolvedChildren = child == null ? children! : <Widget>[child!, ...children!];
      if (isStack) {
        current = buildStack(resolvedChildren);
      } else if (isWrap) {
        current = buildWrap(resolvedChildren);
      } else {
        current = buildFlex(resolvedChildren);
      }
    } else if (child != null) {
      current = child!;
    }
    if (intrinsicWidth) {
      current = IntrinsicWidth(stepWidth: stepWidth, stepHeight: stepHeight, child: current);
    }
    if (intrinsicHeight) current = IntrinsicHeight(child: current);
    current = buildPadding(current);
    if (isScroll) current = buildSingleChildScrollView(context, current);
    if (alignment != null || widthFactor != null || heightFactor != null) {
      current = Align(
        alignment: alignment ?? Alignment.center,
        widthFactor: widthFactor,
        heightFactor: heightFactor,
        child: current,
      );
    }
    if (decoration != null) {
      current = DecoratedBox(
        position: decorationPosition,
        decoration: decoration!.copyWith(
          color: decoration?.color ?? color,
          borderRadius: decoration?.borderRadius ?? borderRadius,
        ),
        child: current,
      );
    } else if (color != null) {
      current = ColoredBox(color: color!, child: current);
    }
    if (buttonCategory != null) {
      current = buildButtonCategory(current);
    } else if (enabledGestureDetector) {
      current = buildGestureDetector(current);
    }
    if (onHover != null && buttonCategory == null) {
      current = MouseRegion(
        onEnter: (PointerEnterEvent _) => onHover!(true),
        onExit: (PointerExitEvent _) => onHover!(false),
        child: current,
      );
    }
    if (heroTag != null) current = buildHero(current);
    current = buildSize(current);
    current = buildClip(current, clipper: clipper);
    if (constraints != null) {
      current = ConstrainedBox(constraints: constraints!, child: current);
    }
    if (margin != null) current = Padding(padding: margin!, child: current);
    if (opacity != null) current = Opacity(opacity: opacity!, child: current);
    if (systemOverlayStyle != null) current = buildAnnotatedRegion(current);
    if (safeLeft || safeTop || safeRight || safeBottom || safeLTRB) {
      current = SafeArea(
        left: safeLTRB ? true : safeLeft,
        top: safeLTRB ? true : safeTop,
        right: safeLTRB ? true : safeRight,
        bottom: safeLTRB ? true : safeBottom,
        child: current,
      );
    }
    assert(
      [
            left != null || top != null || right != null || bottom != null,
            flexible,
            expanded,
          ].where((e) => e == true).length <=
          1,
      "Cannot use 'left/top/right/bottom' (Positioned) with 'flexible' or 'expanded' (Flex widgets) at the same time. They are mutually exclusive layout properties.",
    );
    if (left != null || top != null || right != null || bottom != null) {
      assert(
        context.findAncestorWidgetOfExactType<Stack>() != null,
        "Universal 的 left/top/right/bottom 需要父级为 Stack，例如父组件设置 isStack: true",
      );
      current = Positioned(left: left, top: top, right: right, bottom: bottom, child: current);
    } else {
      current = buildFlexible(current);
    }
    return current;
  }

  Widget buildSize(Widget current) {
    assert(
      [expand, (width != null || height != null), size != null, aspectRatio != null].where((e) => e == true).length <=
          1,
      "Only one of 'expand', 'width/height', 'size', or 'aspectRatio' can be used at the same time (conflicting size controls).",
    );
    if (expand) {
      current = SizedBox.expand(child: current);
    } else if (width != null || height != null) {
      current = SizedBox(width: width, height: height, child: current);
    } else if (size != null) {
      current = SizedBox.fromSize(size: size, child: current);
    } else if (aspectRatio != null) {
      current = AspectRatio(aspectRatio: aspectRatio!, child: current);
    }
    return current;
  }

  Widget buildAnnotatedRegion(Widget current) =>
      AnnotatedRegion<SystemUiOverlayStyle>(sized: sized, value: systemOverlayStyle!, child: current);

  Widget buildPadding(Widget current) =>
      _paddingIncludingDecoration == null ? current : Padding(padding: _paddingIncludingDecoration!, child: current);

  Widget buildClip(Widget current, {CustomClipper<dynamic>? clipper}) {
    assert(
      [isClipRRect, isClipRect, isOval, isClipPath].where((e) => e).length <= 1,
      "Only one of isClipRRect, isClipRect, isOval, isClipPath can be true (conflicting clipping types).",
    );
    if (isOval) {
      return ClipOval(
        clipper: clipper is CustomClipper<Rect> ? clipper : null,
        clipBehavior: clipBehavior ?? Clip.antiAlias,
        child: current,
      );
    } else if (isClipRect) {
      return ClipRect(
        clipper: clipper is CustomClipper<Rect> ? clipper : null,
        clipBehavior: clipBehavior ?? Clip.hardEdge,
        child: current,
      );
    } else if (isClipPath) {
      return ClipPath(
        clipper: clipper is CustomClipper<Path> ? clipper : null,
        clipBehavior: clipBehavior ?? Clip.antiAlias,
        child: current,
      );
    } else if (isClipRRect) {
      return ClipRRect(
        borderRadius: borderRadius ?? BorderRadius.zero,
        clipper: clipper is CustomClipper<RRect> ? clipper : null,
        clipBehavior: clipBehavior ?? Clip.antiAlias,
        child: current,
      );
    }
    return current;
  }

  Widget buildHero(Widget current) => Hero(
    tag: heroTag!,
    createRectTween: createRectTween,
    flightShuttleBuilder: flightShuttleBuilder,
    placeholderBuilder: placeholderBuilder,
    transitionOnUserGestures: transitionOnUserGestures,
    child: current,
  );

  Widget buildFlexible(Widget current) {
    if (flexible) {
      current = Flexible(flex: flex, child: current);
    } else if (expanded) {
      current = Expanded(flex: flex, child: current);
    }
    return current;
  }

  Widget buildSingleChildScrollView(BuildContext context, Widget current) {
    final Widget scrollView = SingleChildScrollView(
      physics: physics,
      reverse: reverse,
      primary: primary,
      dragStartBehavior: dragStartBehavior,
      controller: scrollController,
      scrollDirection: scrollDirection ?? direction,
      clipBehavior: clipBehavior ?? Clip.hardEdge,
      restorationId: restorationId,
      keyboardDismissBehavior: keyboardDismissBehavior,
      child: current,
    );
    if (!noScrollBehavior) return scrollView;
    return ScrollConfiguration(
      behavior: ScrollConfiguration.of(context).copyWith(overscroll: false),
      child: scrollView,
    );
  }

  Widget buildFlex(List<Widget> children) => Flex(
    spacing: spacing,
    mainAxisAlignment: mainAxisAlignment,
    crossAxisAlignment: crossAxisAlignment,
    direction: direction,
    textBaseline: textBaseline,
    verticalDirection: verticalDirection,
    textDirection: textDirection,
    mainAxisSize: mainAxisSize,
    clipBehavior: clipBehavior ?? Clip.none,
    children: children,
  );

  Widget buildWrap(List<Widget> children) => Wrap(
    direction: direction,
    alignment: wrapAlignment,
    spacing: spacing,
    runAlignment: runAlignment,
    runSpacing: runSpacing,
    crossAxisAlignment: wrapCrossAxisAlignment,
    clipBehavior: clipBehavior ?? Clip.none,
    verticalDirection: verticalDirection,
    textDirection: textDirection,
    children: children,
  );

  Widget buildStack(List<Widget> children) => Stack(
    alignment: stackAlignment,
    textDirection: textDirection,
    fit: stackFit,
    clipBehavior: clipBehavior ?? Clip.hardEdge,
    children: children,
  );

  Widget buildButtonCategory(Widget current) => FlButton(
    category: buttonCategory!,
    onPressed: onTap ?? onPressed,
    onLongPress: onLongPress,
    onHover: onHover,
    onFocusChange: onFocusChange,
    style: style,
    clipBehavior: clipBehavior ?? Clip.none,
    focusNode: focusNode,
    autofocus: autofocus,
    statesController: statesController,
    child: current,
  );

  Widget buildGestureDetector(Widget current) => GestureDetector(
    onTap: onTap ?? onPressed,
    onTapDown: onTapDown,
    onTapUp: onTapUp,
    onTapCancel: onTapCancel,
    onDoubleTap: onDoubleTap,
    onDoubleTapDown: onDoubleTapDown,
    onDoubleTapCancel: onDoubleTapCancel,
    onLongPress: onLongPress,
    onLongPressStart: onLongPressStart,
    onLongPressMoveUpdate: onLongPressMoveUpdate,
    onLongPressUp: onLongPressUp,
    onLongPressEnd: onLongPressEnd,
    onLongPressCancel: onLongPressCancel,
    onLongPressDown: onLongPressDown,
    onSecondaryTapDown: onSecondaryTapDown,
    onSecondaryTapUp: onSecondaryTapUp,
    onSecondaryTapCancel: onSecondaryTapCancel,
    onSecondaryTap: onSecondaryTap,
    onSecondaryLongPressMoveUpdate: onSecondaryLongPressMoveUpdate,
    onSecondaryLongPressUp: onSecondaryLongPressUp,
    onSecondaryLongPress: onSecondaryLongPress,
    onSecondaryLongPressEnd: onSecondaryLongPressEnd,
    onSecondaryLongPressStart: onSecondaryLongPressStart,
    onSecondaryLongPressCancel: onSecondaryLongPressCancel,
    onSecondaryLongPressDown: onSecondaryLongPressDown,
    onVerticalDragDown: onVerticalDragDown,
    onVerticalDragStart: onVerticalDragStart,
    onVerticalDragUpdate: onVerticalDragUpdate,
    onVerticalDragEnd: onVerticalDragEnd,
    onVerticalDragCancel: onVerticalDragCancel,
    onHorizontalDragDown: onHorizontalDragDown,
    onHorizontalDragStart: onHorizontalDragStart,
    onHorizontalDragUpdate: onHorizontalDragUpdate,
    onHorizontalDragEnd: onHorizontalDragEnd,
    onHorizontalDragCancel: onHorizontalDragCancel,
    onForcePressStart: onForcePressStart,
    onForcePressPeak: onForcePressPeak,
    onForcePressUpdate: onForcePressUpdate,
    onForcePressEnd: onForcePressEnd,
    onTertiaryLongPress: onTertiaryLongPress,
    onTertiaryLongPressCancel: onTertiaryLongPressCancel,
    onTertiaryLongPressDown: onTertiaryLongPressDown,
    onTertiaryLongPressEnd: onTertiaryLongPressEnd,
    onTertiaryLongPressMoveUpdate: onTertiaryLongPressMoveUpdate,
    onTertiaryLongPressStart: onTertiaryLongPressStart,
    onTertiaryLongPressUp: onTertiaryLongPressUp,
    onTertiaryTapCancel: onTertiaryTapCancel,
    onTertiaryTapDown: onTertiaryTapDown,
    onTertiaryTapUp: onTertiaryTapUp,
    onPanDown: onPanDown,
    onPanStart: onPanStart,
    onPanUpdate: onPanUpdate,
    onPanEnd: onPanEnd,
    onPanCancel: onPanCancel,
    onScaleStart: onScaleStart,
    onScaleUpdate: onScaleUpdate,
    onScaleEnd: onScaleEnd,
    behavior: behavior,
    excludeFromSemantics: excludeFromSemantics,
    dragStartBehavior: dragStartBehavior,
    supportedDevices: supportedDevices,
    trackpadScrollCausesScale: trackpadScrollCausesScale,
    trackpadScrollToScaleFactor: trackpadScrollToScaleFactor,
    child: current,
  );

  bool get enabledGestureDetector =>
      onTap != null ||
      onPressed != null ||
      onDoubleTap != null ||
      onLongPress != null ||
      onTapDown != null ||
      onTapUp != null ||
      onTapCancel != null ||
      onDoubleTapDown != null ||
      onDoubleTapCancel != null ||
      onLongPressStart != null ||
      onLongPressMoveUpdate != null ||
      onLongPressUp != null ||
      onLongPressEnd != null ||
      onLongPressCancel != null ||
      onLongPressDown != null ||
      onSecondaryTapDown != null ||
      onSecondaryTapUp != null ||
      onSecondaryTapCancel != null ||
      onSecondaryTap != null ||
      onSecondaryLongPressMoveUpdate != null ||
      onSecondaryLongPressUp != null ||
      onSecondaryLongPress != null ||
      onSecondaryLongPressEnd != null ||
      onSecondaryLongPressStart != null ||
      onSecondaryLongPressCancel != null ||
      onSecondaryLongPressDown != null ||
      onVerticalDragDown != null ||
      onVerticalDragStart != null ||
      onVerticalDragUpdate != null ||
      onVerticalDragEnd != null ||
      onVerticalDragCancel != null ||
      onHorizontalDragDown != null ||
      onHorizontalDragStart != null ||
      onHorizontalDragUpdate != null ||
      onHorizontalDragEnd != null ||
      onHorizontalDragCancel != null ||
      onForcePressStart != null ||
      onForcePressPeak != null ||
      onForcePressUpdate != null ||
      onForcePressEnd != null ||
      onTertiaryLongPress != null ||
      onTertiaryLongPressCancel != null ||
      onTertiaryLongPressDown != null ||
      onTertiaryLongPressEnd != null ||
      onTertiaryLongPressMoveUpdate != null ||
      onTertiaryLongPressStart != null ||
      onTertiaryLongPressUp != null ||
      onTertiaryTapCancel != null ||
      onTertiaryTapDown != null ||
      onTertiaryTapUp != null ||
      onPanDown != null ||
      onPanStart != null ||
      onPanUpdate != null ||
      onPanEnd != null ||
      onPanCancel != null ||
      onScaleStart != null ||
      onScaleUpdate != null ||
      onScaleEnd != null;
}
