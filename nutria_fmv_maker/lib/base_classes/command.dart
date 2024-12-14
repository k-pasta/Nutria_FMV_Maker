abstract class Command {
///Interface for creating undo/redo patterns
///implement this to any function needs to be put in the undo & redo stacks.
  void execute();
  void undo();
}