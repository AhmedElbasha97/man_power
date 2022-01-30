class Vacancy {
  Vacancy({
    this.jobId,
    this.title,
    this.notes,
    this.salary,
    this.jobLocation,
    this.jobType,
    this.details,
    this.created,
  });

  String? jobId;
  String? title;
  String? notes;
  String? salary;
  String? jobLocation;
  String? jobType;
  String? details;
  String? created;

  factory Vacancy.fromJson(Map<String, dynamic> json) => Vacancy(
        jobId: json["job_id"],
        title: json["title"] == null ? " - " : json["title"],
        notes: json["notes"] == null ? " - " : json["notes"],
        salary: json["salary"] == null ? " - " : json["salary"],
        jobLocation:
            json["job_location"] == " - " ? null : json["job_location"],
        jobType: json["job_type"] == null ? " - " : json["job_type"],
        details: json["details"] == null ? " - " : json["details"],
        created: json["created"] == null ? " - " : json["created"],
      );
}
