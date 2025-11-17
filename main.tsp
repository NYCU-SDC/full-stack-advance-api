import "@typespec/http";
import "@typespec/versioning";

using Http;
using Versioning;

@service(#{ title: "SDC Tasks API", version: "1.0.0" })
@server("https://example.com", "Single server endpoint")
@versioned(Versions)
@route("/api")
namespace SDCTasksAPI;

enum Versions {
  v1: "1.0.0",
}

model TaskResponse {
  id: int32;
  labels: string[];
  title: string;
  description: string;
  status: string;
  dueDate: string;

  // assignee: string;
  createdAt: string;

  updatedAt: string;
}

model CreateTaskRequest {
  title: string;
}

model UpdateTaskRequest {
  title: string;
  description: string;
  status: string;
  dueDate: string;
  labels: string[];
}

@tag("Tasks")
namespace SDCTasksAPI.Tasks {
  @route("/task")
  @get
  op getAllTasks(): {
    @statusCode statusCode: 200;
    @body body: TaskResponse[];
  };

  @route("/task/{id}")
  @get
  op getTaskById(@path id: int32): {
    @statusCode statusCode: 200;
    @body body: TaskResponse;
  } | {
    @statusCode statusCode: 404;
  };

  @route("/task")
  @post
  op createTask(@body request: CreateTaskRequest): {
    @statusCode statusCode: 201;
    @body body: TaskResponse;
  };

  @route("/task/{id}")
  @put
  op updateTask(@path id: int32, @body request: UpdateTaskRequest): {
    @statusCode statusCode: 200;
    @body body: TaskResponse;
  } | {
    @statusCode statusCode: 404;
  };

  @route("/task/{id}")
  @delete
  op deleteTask(@path id: int32): {
    @statusCode statusCode: 204;
  } | {
    @statusCode statusCode: 404;
  };
}

@tag("Auth")
namespace SDCTasksAPI.Auth {
  @doc("If successful, the callback URL will include additional query parameters, `access_token` and `refresh_token`.")
  @route("/login/auth/google")
  @get
  op login(
    @doc("The callback url that backend redirect back to frontend")
    @query
    c: string,

    @doc("The url that frontend redirect from callback to the page user was viewing")
    @query
    r?: string,
  ): {
    @statusCode
    statusCode: 302;
  } | {
    @statusCode statusCode: 404;
  };

  @route("/logout")
  @get
  op logout(): {
    @statusCode
    statusCode: 204;
  };
}
