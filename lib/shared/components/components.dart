import 'package:conditional_builder/conditional_builder.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:todo_app/shared/cubit/cubit.dart';

Widget defaultTextForm({
  @required TextEditingController controller,
  @required TextInputType type,
  Function onSubmit,
  Function onChange,
  Function onTap,
  bool isPassword = false,
  @required Function validate,
  @required String label,
  @required IconData prefix,
  IconData suffix,
  Function suffixPressed,
  bool isClickable = true,
}) =>
    Container(
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          5.0,
        ),
        color: Colors.white,
      ),
      padding: EdgeInsetsDirectional.only(
        start: 10.0,
        end: 10.0,
        top: 10.0,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextFormField(
            controller: controller,
            keyboardType: type,
            obscureText: isPassword,
            enabled: isClickable,
            onFieldSubmitted: onSubmit,
            onChanged: onChange,
            onTap: onTap,
            validator: validate,
            decoration: InputDecoration(
              labelText: label,
              prefixIcon: Icon(
                prefix,
              ),
              suffixIcon: suffix != null
                  ? Icon(
                      suffix,
                    )
                  : null,
              border: OutlineInputBorder(),
            ),
          ),
        ],
      ),
    );

Widget buildTaskItem(Map taskModel, BuildContext context) => Dismissible(
      key: Key(taskModel['id'].toString()),
      onDismissed: (direction)
      {
        AppCubit.get(context).deleteData(id: taskModel['id']);
      },
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Row(
          children: [
            CircleAvatar(
              radius: 40.0,
              child: Text(
                '${taskModel['time']}',
              ),
            ),
            SizedBox(width: 20.0),
            Expanded(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${taskModel['title']}',
                    style: TextStyle(
                      fontSize: 20.0,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    '${taskModel['date']}',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            ),
            SizedBox(width: 20.0),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateData(status: 'done', id: taskModel['id']);
              },
              icon: Icon(Icons.check_box),
              color: Colors.green,
            ),
            IconButton(
              onPressed: () {
                AppCubit.get(context)
                    .updateData(status: 'archive', id: taskModel['id']);
              },
              icon: Icon(Icons.archive),
              color: Colors.black45,
            ),
          ],
        ),
      ),
    );

Widget conditionalItemBuilder ({
  @required List<Map> tasks,
}) => ConditionalBuilder(
  condition: tasks.length > 0,
  builder: (context) => ListView.separated(
    itemBuilder: (context, index) => buildTaskItem(tasks[index], context),
    separatorBuilder: (context, index) => Padding(
      padding: const EdgeInsetsDirectional.only(
        start: 20.0,
      ),
      child: Container(
        width: double.infinity,
        height: 1.0,
        color: Colors.grey[300],
      ),
    ),
    itemCount: tasks.length,
  ),
  fallback: (context) => Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(
          Icons.menu,
          size: 100.0,
          color: Colors.grey,
        ),
        Text(
          'No Tasks Yet, Please Add Some Tasks',
          style: TextStyle(
            fontSize: 16.0,
            fontWeight: FontWeight.bold,
            color: Colors.grey,
          ),
        ),
      ],
    ),
  ),
);
