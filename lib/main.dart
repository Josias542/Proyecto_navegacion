import 'package:flutter/material.dart';
import 'dart:html' as html;


void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  int _selectedIndex = 0;
  List<Map<String, String>> _notes = [];

  void _addNote(String title, String content) {
    setState(() {
      _notes.add({'title': title, 'content': content});
    });
  }

  void _deleteNote(int index) {
    setState(() {
      _notes.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Row(
          children: [
            NavigationRail(
              selectedIndex: _selectedIndex,
              onDestinationSelected: (int index) {
                setState(() {
                  _selectedIndex = index;
                });
              },
              labelType: NavigationRailLabelType.all,
              destinations: [
                NavigationRailDestination(
                  icon: Icon(Icons.notes),
                  label: Text('Notas'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.add),
                  label: Text('Nueva Nota'),
                ),
                NavigationRailDestination(
                  icon: Icon(Icons.person),
                  label: Text('Usuario'),
                ),
              ],
            ),
            Expanded(
              child: IndexedStack(
                index: _selectedIndex,
                children: [
                  NotesScreen(notes: _notes, onDelete: _deleteNote),
                  NewNoteScreen(onAddNote: _addNote),
                  UserScreen(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class NotesScreen extends StatelessWidget {
  final List<Map<String, String>> notes;
  final Function(int) onDelete;

  NotesScreen({required this.notes, required this.onDelete});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lista de Notas')),
      body: ListView.builder(
        itemCount: notes.length,
        itemBuilder: (context, index) {
          return Card(
            child: ListTile(
              title: Text(notes[index]['title']!),
              subtitle: Text(notes[index]['content']!),
              trailing: IconButton(
                icon: Icon(Icons.delete, color: Colors.red),
                onPressed: () => onDelete(index),
              ),
            ),
          );
        },
      ),
    );
  }
}

class NewNoteScreen extends StatefulWidget {
  final Function(String, String) onAddNote;

  NewNoteScreen({required this.onAddNote});

  @override
  _NewNoteScreenState createState() => _NewNoteScreenState();
}

class _NewNoteScreenState extends State<NewNoteScreen> {
  final _titleController = TextEditingController();
  final _contentController = TextEditingController();

  void _saveNote() {
    if (_titleController.text.isNotEmpty && _contentController.text.isNotEmpty) {
      widget.onAddNote(_titleController.text, _contentController.text);
      _titleController.clear();
      _contentController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Nueva Nota')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: _titleController,
              decoration: InputDecoration(labelText: 'Título'),
            ),
            TextField(
              controller: _contentController,
              decoration: InputDecoration(labelText: 'Contenido'),
              maxLines: 4,
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveNote,
              child: Text('Guardar Nota'),
            ),
          ],
        ),
      ),
    );
  }
}

class UserScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Información del Usuario')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://via.placeholder.com/150'),
            ),
            SizedBox(height: 10),
            Text('Nombre: Josias David Alcalá Gomez', style: TextStyle(fontSize: 18)),
            Text('Email: gomezjosias542@gmail.com', style: TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}
