import 'package:bloctestapp/bloc/notes_bloc.dart';
import 'package:bloctestapp/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class NoteDetailPage2 extends StatefulWidget {
  final String title;
  final String content;
  final String category;
  final Color categoryColor;
  final String idGeter;
  final String dateTime;

  const NoteDetailPage2({
    super.key,
    required this.title,
    required this.content,
    required this.category,
    required this.categoryColor,
    required this.dateTime,
    required this.idGeter,
  });

  @override
  State<NoteDetailPage2> createState() => _NoteDetailPage2State();
}

class _NoteDetailPage2State extends State<NoteDetailPage2> {
  bool isEditing = false;
  String _selectedCategory = ''; // 👈 локальное состояние категории

  late final TextEditingController controller = TextEditingController(
    text: widget.title,
  );

  late final TextEditingController controllerForContent = TextEditingController(
    text: widget.content,
  );

  @override
  void initState() {
    super.initState();
    _selectedCategory = widget.category; // 👈 инициализируем категорию
  }

  @override
  void dispose() {
    controller.dispose();
    controllerForContent.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18, 18, 18, 28),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildTopBar(context),
              const SizedBox(height: 24),
              _buildTitle(),
              const SizedBox(height: 16),
              Row(
                children: [
                  Text(
                    'Категория',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey[600],
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  const SizedBox(width: 10),
                  _buildCategoryBadge(),
                  const Spacer(),
                ],
              ),
              const SizedBox(height: 18),
              _buildDivider(),
              const SizedBox(height: 10),
              _buildContent(),
            ],
          ),
        ),
      ),
      floatingActionButton: isEditing ? _buildEditButtons() : const SizedBox(),
    );
  }

  // 👇 Кнопки редактирования
  Widget _buildEditButtons() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        ElevatedButton(
          onPressed: _saveChanges,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
            elevation: 6,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            'Сохранить',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
        const SizedBox(height: 10),
        ElevatedButton(
          onPressed: () {
            setState(() {
              isEditing = false;
              // 👇 Восстанавливаем оригинальные значения
              controller.text = widget.title;
              controllerForContent.text = widget.content;
              _selectedCategory = widget.category;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.grey.shade300,
            foregroundColor: Colors.black87,
            elevation: 0,
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 15),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
          ),
          child: const Text(
            'Отмена',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
          ),
        ),
      ],
    );
  }

  // 👇 Сохранение изменений
  void _saveChanges() {
    final updatedNote = Notes(
      id: widget.idGeter,
      title: controller.text,
      description: controllerForContent.text,
      category: _selectedCategory, // 👈 используем локальную категорию
      date: DateTime.now(), // или оригинальную дату
    );

    context.read<NotesBloc>().add(UpdateNote(updatedNote));

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('✅ Заметка обновлена'),
        backgroundColor: Colors.green,
        duration: Duration(seconds: 1),
      ),
    );

    setState(() => isEditing = false);
  }

  // 👇 Верхняя панель с кнопками
  Widget _buildTopBar(BuildContext context) {
    return Row(
      children: [
        // Кнопка назад
        InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: () => Navigator.pop(context),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: const Color.fromARGB(75, 0, 0, 0)),
            ),
            child: const Center(
              child: Icon(Icons.arrow_back_ios_rounded, size: 20),
            ),
          ),
        ),
        const Spacer(),

        // Кнопка редактировать
        InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: () {
            setState(() {
              isEditing = !isEditing;
            });
          },
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: const Color.fromARGB(75, 0, 0, 0)),
            ),
            child: const Center(child: Icon(Icons.edit_outlined, size: 20)),
          ),
        ),
        const SizedBox(width: 10),

        // Кнопка удалить
        InkWell(
          borderRadius: BorderRadius.circular(40),
          onTap: () => _showDeleteDialog(context, widget.idGeter),
          child: Container(
            height: 50,
            width: 50,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(40),
              border: Border.all(color: const Color.fromARGB(75, 0, 0, 0)),
            ),
            child: const Center(
              child: Icon(
                Icons.delete_outline_outlined,
                color: Colors.red,
                size: 20,
              ),
            ),
          ),
        ),
      ],
    );
  }

  // 👇 Бейдж категории
  Widget _buildCategoryBadge() {
    return InkWell(
      borderRadius: const BorderRadius.all(Radius.circular(10)),
      onTap: () {
        showModalBottomSheet(
          context: context,
          backgroundColor: Colors.transparent,
          builder: (sheetContext) {
            return Container(
              padding: const EdgeInsets.all(28),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: BlocBuilder<NotesBloc, NotesState>(
                builder: (context, state) {
                  if (state is NotesLoaded) {
                    final uniqueCategories = state.notes
                        .map((note) => note.category)
                        .toSet()
                        .toList();

                    return Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Выберите категорию',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (uniqueCategories.isEmpty)
                          const Center(child: Text('Нет категорий'))
                        else
                          ...uniqueCategories.map((category) {
                            return _categoRyContainer(category, widget.idGeter);
                          }),
                      ],
                    );
                  }
                  return const Center(child: CircularProgressIndicator());
                },
              ),
            );
          },
        );
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 17, vertical: 3),
        decoration: BoxDecoration(
          color: widget.categoryColor.withOpacity(0.1),
          borderRadius: BorderRadius.circular(25),
          border: Border.all(
            color: widget.categoryColor.withOpacity(0.3),
            width: 0.5,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedCategory, // 👈 показываем актуальную категорию
              style: TextStyle(
                fontSize: 14,
                color: widget.categoryColor,
                fontWeight: FontWeight.w600,
              ),
            ),
            Icon(Icons.arrow_drop_down, color: widget.categoryColor),
          ],
        ),
      ),
    );
  }

  // 👇 Контейнер категории в списке
  Widget _categoRyContainer(String categName, String noteId) {
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = categName;
        });

        context.read<NotesBloc>().add(
          UpdateNoteCategory(noteId: noteId, newCategory: categName),
        );
        Navigator.pop(context);
      },
      borderRadius: BorderRadius.circular(20),
      child: Container(
        height: 40,
        padding: const EdgeInsets.all(5),
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: const Color.fromARGB(255, 187, 222, 251),
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 16,
              offset: const Offset(0, 2),
            ),
            BoxShadow(
              color: Colors.black.withOpacity(0.02),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Text(
            categName,
            style: const TextStyle(
              fontSize: 14,
              color: Color.fromARGB(255, 69, 100, 240),
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }

  // 👇 Заголовок
  Widget _buildTitle() {
    return isEditing
        ? TextField(
            decoration: const InputDecoration(
              hintText: 'Введите заголовок...',
              border: InputBorder.none,
              isDense: true,
              contentPadding: EdgeInsets.symmetric(vertical: 12),
            ),
            controller: controller,
            autofocus: true,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              height: 1.2,
              color: Colors.black,
            ),
          )
        : Text(
            widget.title,
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.w700,
              height: 1.2,
              color: Colors.black,
            ),
          );
  }

  // 👇 Разделитель
  Widget _buildDivider() {
    return Container(
      height: 1,
      decoration: BoxDecoration(color: Colors.grey[200]),
    );
  }

  // 👇 Контент заметки
  Widget _buildContent() {
    return Expanded(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: isEditing
            ? TextField(
                maxLines: null,
                decoration: const InputDecoration(
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.symmetric(vertical: 12),
                ),
                controller: controllerForContent,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.grey[800],
                ),
              )
            : Text(
                widget.content,
                style: TextStyle(
                  fontSize: 16,
                  height: 1.6,
                  color: Colors.grey[800],
                ),
              ),
      ),
    );
  }

  // 👇 Диалог подтверждения удаления
  void _showDeleteDialog(BuildContext context, String idd) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Удалить заметку?'),
        content: const Text('Это действие нельзя будет отменить.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('Отмена', style: TextStyle(color: Colors.grey[600])),
          ),
          TextButton(
            onPressed: () {
              context.read<NotesBloc>().add(DeleteNote(idd));
              Navigator.pop(ctx);
              Navigator.pop(context);
            },
            child: const Text('Удалить', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
