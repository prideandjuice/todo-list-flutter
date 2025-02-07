import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/task_model.dart';
import '../providers/task_provider.dart';

class TaskTile extends StatelessWidget {
  final int index; //menyimpan jumlah tugas di dalam daftar
  final Task task; //menyimpan data tugas yang ditampilkan

  const TaskTile({required this.index, required this.task, Key? key}) : super(key: key);
// - sebagai construct, {} menandakan bahwa parameter bersifat named parameters.
//- required berarti parameter wajib diisi saat membuat object TaskTile.
//- this.index dan this.task menyimpan nilai yang dikirim ke dalam instance class TaskTile.
// - Key? key adalah optional parameter yang digunakan oleh super.key.
  @override
  Widget build(BuildContext context) {
    final taskProvider = Provider.of<TaskProvider>(context, listen: false);

    return Dismissible(
      //Widget yang memungkinkan pengguna menghapus item dengan menggesernya ke kiri atau kanan.
      key: Key(task.title),
      onDismissed: (direction) { //fungsi ini akan dipanggil untuk menghapus task berdasarkan index.
        taskProvider.deleteTask(index);
      },
      background: Container(
        color: Colors.red,
        alignment: Alignment.centerRight,
    padding: EdgeInsets.symmetric(horizontal: 20),
    child: Icon(Icons.delete, color: Colors.white, size: 30),
      ),
      child: ListTile(
        title: Text(task.title),
        leading: Checkbox(
          value: task.isCompleted,
          onChanged: (value) {
            taskProvider.toggleTask(index);
          },
        ),
      ),
    );
  }
}
