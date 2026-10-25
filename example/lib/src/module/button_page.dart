import 'package:example/src/demo/demo_widgets.dart';
import 'package:fl_extended/fl_extended.dart';
import 'package:flutter/material.dart';

class ButtonPage extends StatelessWidget {
  const ButtonPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DemoPage(
      title: 'Button & IconLabel',
      description:
          'FlButton 统一了 Material 的五种按钮类型，并支持图标、长按、悬停、焦点与状态控制器；'
          'IconLabel 用于快速组合图标与文案，也可以直接包装成按钮。',
      sections: [
        DemoSection(
          title: 'FlButton 类型',
          description: '通过 category 切换 Text / Filled / FilledTonal / Elevated / Outlined。',
          children: [
            DemoItem(
              title: '五种类型',
              code: "FlButton(category: FlButtonCategory.filled, onPressed: () {}, child: Text('Filled'))",
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: FlButtonCategory.values
                    .map(
                      (FlButtonCategory category) => FlButton(
                        category: category,
                        onPressed: () => showToast('FlButton(${category.name})'),
                        child: Text(category.name),
                      ),
                    )
                    .toList(),
              ),
            ),
            DemoItem(
              title: '禁用状态',
              description: 'onPressed 为 null 时按钮自动禁用。',
              code: "FlButton(onPressed: null, child: Text('disabled'))",
              child: FlButton(onPressed: null, child: const Text('disabled')),
            ),
          ],
        ),
        DemoSection(
          title: 'FlButton.icon',
          description: '图标与文案自动按文字缩放比例调整间距，可指定 iconAlignment。',
          children: [
            DemoItem(
              title: '图标位置',
              code: "FlButton.icon(icon: Icon(Icons.add), iconAlignment: IconAlignment.end, onPressed: onTap, child: Text('Icon'))",
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: FlButtonCategory.values
                    .map(
                      (FlButtonCategory category) => FlButton.icon(
                        icon: const Icon(Icons.ac_unit_rounded),
                        category: category,
                        onPressed: () => showToast('FlButton.icon(${category.name})'),
                        child: Text(category.name),
                      ),
                    )
                    .toList(),
              ),
            ),
            DemoItem(
              title: '图标在右侧 + 内边距',
              code: "FlButton.icon(icon: Icon(Icons.arrow_forward), iconAlignment: IconAlignment.end, padding: EdgeInsets.symmetric(horizontal: 18, vertical: 12), onPressed: onTap, child: Text('Next'))",
              child: FlButton.icon(
                icon: const Icon(Icons.arrow_forward_rounded),
                iconAlignment: IconAlignment.end,
                padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                onPressed: () => showToast('Next'),
                child: const Text('Next'),
              ),
            ),
          ],
        ),
        DemoSection(
          title: 'IconLabel',
          description: '图标 + 文案组合，适合列表项、设置项、底部导航等场景。',
          children: [
            DemoItem(
              title: '基础组合',
              code: "IconLabel(icon: Icons.person_rounded, labelText: 'Profile')",
              child: const IconLabel(icon: Icons.person_rounded, labelText: 'Profile'),
            ),
            DemoItem(
              title: '反转 / 垂直排列',
              code:
                  "IconLabel(icon: Icons.home_rounded, labelText: 'Home', reverse: true)\n"
                  "IconLabel(icon: Icons.settings_rounded, labelText: 'Settings', direction: Axis.vertical)",
              child: Wrap(
                spacing: 20,
                runSpacing: 12,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: const [
                  IconLabel(icon: Icons.home_rounded, labelText: 'Home', reverse: true),
                  IconLabel(icon: Icons.settings_rounded, labelText: 'Settings', direction: Axis.vertical),
                ],
              ),
            ),
            DemoItem(
              title: '包装成按钮',
              code: "IconLabel(icon: Icons.add_rounded, labelText: 'Add', buttonCategory: FlButtonCategory.filled, onTap: onTap)",
              child: Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  IconLabel(
                    icon: Icons.add_rounded,
                    labelText: 'Filled',
                    buttonCategory: FlButtonCategory.filled,
                    onTap: () => showToast('IconLabel Filled'),
                  ),
                  IconLabel(
                    icon: Icons.wallet_rounded,
                    labelText: 'Outlined',
                    buttonCategory: FlButtonCategory.outlined,
                    onTap: () => showToast('IconLabel Outlined'),
                  ),
                ],
              ),
            ),
            DemoItem(
              title: '自定义图标组件与颜色',
              code: "IconLabel(widget: Icon(Icons.star_rounded), label: Text('Favorite'), color: Colors.amber, onTap: onTap)",
              child: IconLabel(
                widget: const Icon(Icons.star_rounded),
                label: const Text('Favorite'),
                color: Colors.amber,
                onTap: () => showToast('Favorite'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
