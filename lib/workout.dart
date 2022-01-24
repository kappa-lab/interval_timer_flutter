class WorkOut {
  final int time;
  final int reps;

  WorkOut(this.time, this.reps);

  WorkOut increment() {
    return WorkOut(time, reps + 1);
  }
}
