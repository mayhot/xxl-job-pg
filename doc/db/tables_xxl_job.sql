--
-- XXL-JOB
-- Copyright (c) 2015-present, xuxueli.
-- SQL translated by niangao

-- 1.create table
CREATE TABLE "xxl_job_group"
(
    "id"           INT4                                       NOT NULL GENERATED ALWAYS AS IDENTITY,
    "app_name"     VARCHAR(64) COLLATE "pg_catalog"."default" NOT NULL,
    "title"        VARCHAR(12) COLLATE "pg_catalog"."default" NOT NULL,
    "address_type" INT2                                       NOT NULL DEFAULT 0,
    "address_list" TEXT COLLATE "pg_catalog"."default",
    "update_time"  TIMESTAMP(6),
    CONSTRAINT "xxl_job_group_pkey" PRIMARY KEY ("id")
);
COMMENT ON COLUMN "xxl_job_group"."app_name" IS '执行器AppName';
COMMENT ON COLUMN "xxl_job_group"."title" IS '执行器名称';
COMMENT ON COLUMN "xxl_job_group"."address_type" IS '执行器地址类型：0=自动注册、1=手动录入';
COMMENT ON COLUMN "xxl_job_group"."address_list" IS '执行器地址列表，多地址逗号分隔';

CREATE TABLE "xxl_job_info"
(
    "id"                        int4                                        NOT NULL GENERATED ALWAYS AS IDENTITY,
    "job_group"                 int4                                        NOT NULL,
    "job_desc"                  varchar(255) COLLATE "pg_catalog"."default" NOT NULL,
    "add_time"                  timestamp(6),
    "update_time"               timestamp(6),
    "author"                    varchar(64) COLLATE "pg_catalog"."default",
    "alarm_email"               varchar(255) COLLATE "pg_catalog"."default" ,
    "schedule_type"             varchar(50) COLLATE "pg_catalog"."default"  NOT NULL DEFAULT 'NONE'::character varying,
    "schedule_conf"             varchar(128) COLLATE "pg_catalog"."default",
    "misfire_strategy"          varchar(50) COLLATE "pg_catalog"."default"  NOT NULL DEFAULT 'DO_NOTHING'::character varying,
    "executor_route_strategy"   varchar(50) COLLATE "pg_catalog"."default",
    "executor_handler"          varchar(255) COLLATE "pg_catalog"."default",
    "executor_param"            varchar(512) COLLATE "pg_catalog"."default",
    "executor_block_strategy"   varchar(50) COLLATE "pg_catalog"."default",
    "executor_timeout"          int4                                        NOT NULL DEFAULT 0,
    "executor_fail_retry_count" int4                                        NOT NULL DEFAULT 0,
    "glue_type"                 varchar(50) COLLATE "pg_catalog"."default"  NOT NULL,
    "glue_source"               text COLLATE "pg_catalog"."default",
    "glue_remark"               varchar(128) COLLATE "pg_catalog"."default",
    "glue_updatetime"           timestamp(6),
    "child_jobid"               varchar(255) COLLATE "pg_catalog"."default",
    "trigger_status"            int2                                        NOT NULL DEFAULT 0,
    "trigger_last_time"         int8                                        NOT NULL DEFAULT 0,
    "trigger_next_time"         int8                                        NOT NULL DEFAULT 0,
    CONSTRAINT "xxl_job_info_pkey" PRIMARY KEY ("id")
)
;
COMMENT ON COLUMN "xxl_job_info"."job_group" IS '执行器主键ID';
COMMENT ON COLUMN "xxl_job_info"."author" IS '作者';
COMMENT ON COLUMN "xxl_job_info"."alarm_email" IS '报警邮件';
COMMENT ON COLUMN "xxl_job_info"."schedule_type" IS '调度类型';
COMMENT ON COLUMN "xxl_job_info"."schedule_conf" IS '调度配置，值含义取决于调度类型';
COMMENT ON COLUMN "xxl_job_info"."misfire_strategy" IS '调度过期策略';
COMMENT ON COLUMN "xxl_job_info"."executor_route_strategy" IS '执行器路由策略';
COMMENT ON COLUMN "xxl_job_info"."executor_handler" IS '执行器任务handler';
COMMENT ON COLUMN "xxl_job_info"."executor_param" IS '执行器任务参数';
COMMENT ON COLUMN "xxl_job_info"."executor_block_strategy" IS '阻塞处理策略';
COMMENT ON COLUMN "xxl_job_info"."executor_timeout" IS '任务执行超时时间，单位秒';
COMMENT ON COLUMN "xxl_job_info"."executor_fail_retry_count" IS '失败重试次数';
COMMENT ON COLUMN "xxl_job_info"."glue_type" IS 'GLUE类型';
COMMENT ON COLUMN "xxl_job_info"."glue_source" IS 'GLUE源代码';
COMMENT ON COLUMN "xxl_job_info"."glue_remark" IS 'GLUE备注';
COMMENT ON COLUMN "xxl_job_info"."glue_updatetime" IS 'GLUE更新时间';
COMMENT ON COLUMN "xxl_job_info"."child_jobid" IS '子任务ID，多个逗号分隔';
COMMENT ON COLUMN "xxl_job_info"."trigger_status" IS '调度状态：0-停止，1-运行';
COMMENT ON COLUMN "xxl_job_info"."trigger_last_time" IS '上次调度时间';
COMMENT ON COLUMN "xxl_job_info"."trigger_next_time" IS '下次调度时间';


CREATE TABLE "xxl_job_lock"
(
    "lock_name" varchar(50) COLLATE "pg_catalog"."default" NOT NULL,
    CONSTRAINT "xxl_job_lock_pkey" PRIMARY KEY ("lock_name")
)
;
COMMENT ON COLUMN "xxl_job_lock"."lock_name" IS '锁名称';


CREATE TABLE "xxl_job_log"
(
    "id"                        INT8 NOT NULL GENERATED ALWAYS AS IDENTITY,
    "job_group"                 INT4 NOT NULL,
    "job_id"                    INT4 NOT NULL,
    "executor_address"          VARCHAR(255) COLLATE "pg_catalog"."default",
    "executor_handler"          VARCHAR(255) COLLATE "pg_catalog"."default",
    "executor_param"            VARCHAR(512) COLLATE "pg_catalog"."default",
    "executor_sharding_param"   VARCHAR(20) COLLATE "pg_catalog"."default",
    "executor_fail_retry_count" INT4 NOT NULL DEFAULT 0,
    "trigger_time"              TIMESTAMP(6),
    "trigger_code"              INT4 NOT NULL,
    "trigger_msg"               TEXT COLLATE "pg_catalog"."default",
    "handle_time"               TIMESTAMP(6),
    "handle_code"               INT4 NOT NULL,
    "handle_msg"                TEXT COLLATE "pg_catalog"."default",
    "alarm_status"              INT2 NOT NULL DEFAULT 0,
    CONSTRAINT "xxl_job_log_pkey" PRIMARY KEY ("id")
);
CREATE INDEX "I_handle_code" ON "xxl_job_log" USING btree ("handle_code" "pg_catalog"."int4_ops" ASC NULLS LAST);
CREATE INDEX "I_job_id" ON "xxl_job_log" USING btree ("job_id" "pg_catalog"."int4_ops" ASC NULLS LAST);
CREATE INDEX "I_jobid_jobgroup" ON "xxl_job_log" USING btree ("job_id" "pg_catalog"."int4_ops" ASC NULLS LAST,
                                                              "job_group" "pg_catalog"."int4_ops" ASC NULLS
                                                              LAST);
CREATE INDEX "I_trigger_time" ON "xxl_job_log" USING btree ("trigger_time" "pg_catalog"."timestamp_ops" ASC NULLS LAST);
COMMENT ON COLUMN "xxl_job_log"."job_group" IS '执行器主键ID';
COMMENT ON COLUMN "xxl_job_log"."job_id" IS '任务，主键ID';
COMMENT ON COLUMN "xxl_job_log"."executor_address" IS '执行器地址，本次执行的地址';
COMMENT ON COLUMN "xxl_job_log"."executor_handler" IS '执行器任务handler';
COMMENT ON COLUMN "xxl_job_log"."executor_param" IS '执行器任务参数';
COMMENT ON COLUMN "xxl_job_log"."executor_sharding_param" IS '执行器任务分片参数，格式如 1/2';
COMMENT ON COLUMN "xxl_job_log"."executor_fail_retry_count" IS '失败重试次数';
COMMENT ON COLUMN "xxl_job_log"."trigger_time" IS '调度-时间';
COMMENT ON COLUMN "xxl_job_log"."trigger_code" IS '调度-结果';
COMMENT ON COLUMN "xxl_job_log"."trigger_msg" IS '调度-日志';
COMMENT ON COLUMN "xxl_job_log"."handle_time" IS '执行-时间';
COMMENT ON COLUMN "xxl_job_log"."handle_code" IS '执行-状态';
COMMENT ON COLUMN "xxl_job_log"."handle_msg" IS '执行-日志';
COMMENT ON COLUMN "xxl_job_log"."alarm_status" IS '告警状态：0-默认、1-无需告警、2-告警成功、3-告警失败';


CREATE TABLE "xxl_job_log_report"
(
    "id"            INT4 NOT NULL GENERATED ALWAYS AS IDENTITY,
    "trigger_day"   TIMESTAMP(6),
    "running_count" INT4 NOT NULL DEFAULT 0,
    "suc_count"     INT4 NOT NULL DEFAULT 0,
    "fail_count"    INT4 NOT NULL DEFAULT 0,
    "update_time"   TIMESTAMP(6),
    CONSTRAINT "xxl_job_log_report_pkey" PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX "i_trigger_day" ON "xxl_job_log_report" USING btree ("trigger_day" "pg_catalog"."timestamp_ops" ASC NULLS LAST);
COMMENT ON COLUMN "xxl_job_log_report"."trigger_day" IS '调度-时间';
COMMENT ON COLUMN "xxl_job_log_report"."running_count" IS '运行中-日志数量';
COMMENT ON COLUMN "xxl_job_log_report"."suc_count" IS '执行成功-日志数量';
COMMENT ON COLUMN "xxl_job_log_report"."fail_count" IS '执行失败-日志数量';

CREATE TABLE "xxl_job_logglue"
(
    "id"          INT4                                        NOT NULL GENERATED ALWAYS AS IDENTITY,
    "job_id"      INT4                                        NOT NULL,
    "glue_type"   VARCHAR(50) COLLATE "pg_catalog"."default",
    "glue_source" TEXT COLLATE "pg_catalog"."default",
    "glue_remark" VARCHAR(128) COLLATE "pg_catalog"."default" NOT NULL,
    "add_time"    TIMESTAMP(6),
    "update_time" TIMESTAMP(6),
    CONSTRAINT "xxl_job_logglue_pkey" PRIMARY KEY ("id")
);
COMMENT ON COLUMN "xxl_job_logglue"."job_id" IS '任务，主键ID';
COMMENT ON COLUMN "xxl_job_logglue"."glue_type" IS 'GLUE类型';
COMMENT ON COLUMN "xxl_job_logglue"."glue_source" IS 'GLUE源代码';
COMMENT ON COLUMN "xxl_job_logglue"."glue_remark" IS 'GLUE备注';

CREATE TABLE "xxl_job_registry"
(
    "id"             INT4                                        NOT NULL GENERATED ALWAYS AS IDENTITY,
    "registry_group" VARCHAR(50) COLLATE "pg_catalog"."default"  NOT NULL,
    "registry_key"   VARCHAR(255) COLLATE "pg_catalog"."default" NOT NULL,
    "registry_value" VARCHAR(255) COLLATE "pg_catalog"."default" NOT NULL,
    "update_time"    TIMESTAMP(6),
    CONSTRAINT "xxl_job_registry_pkey" PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX "i_g_k_v" ON "xxl_job_registry" USING btree (
                                                                 "registry_group"
                                                                 COLLATE "pg_catalog"."default"
                                                                 "pg_catalog"."text_ops" ASC NULLS LAST,
                                                                 "registry_key" COLLATE "pg_catalog"."default"
                                                                 "pg_catalog"."text_ops" ASC NULLS LAST,
                                                                 "registry_value"
                                                                 COLLATE "pg_catalog"."default"
                                                                 "pg_catalog"."text_ops" ASC NULLS LAST);


CREATE TABLE "xxl_job_user"
(
    "id"         INT4                                       NOT NULL GENERATED ALWAYS AS IDENTITY,
    "username"   VARCHAR(50) COLLATE "pg_catalog"."default" NOT NULL,
    "password"   VARCHAR(50) COLLATE "pg_catalog"."default" NOT NULL,
    "role"       INT2                                       NOT NULL,
    "permission" VARCHAR(255) COLLATE "pg_catalog"."default",
    CONSTRAINT "xxl_job_user_pkey" PRIMARY KEY ("id")
);
CREATE UNIQUE INDEX "i_username" ON "xxl_job_user" USING btree ("username" COLLATE "pg_catalog"."default"
                                                                "pg_catalog"."text_ops" ASC NULLS LAST);
COMMENT ON COLUMN "xxl_job_user"."username" IS '账号';
COMMENT ON COLUMN "xxl_job_user"."password" IS '密码';
COMMENT ON COLUMN "xxl_job_user"."role" IS '角色：0-普通用户、1-管理员';
COMMENT ON COLUMN "xxl_job_user"."permission" IS '权限：执行器ID列表，多个逗号分割';

-- 2.init data
INSERT INTO "xxl_job_group" ("app_name", "title", "address_type", "address_list", "update_time")
VALUES ('xxl-job-executor-sample', '示例执行器', 0, NULL, '2018-11-03 22:21:31');

INSERT INTO "xxl_job_info" ("job_group", "job_desc", "add_time", "update_time", "author", "alarm_email",
                            "schedule_type", "schedule_conf", "misfire_strategy", "executor_route_strategy",
                            "executor_handler", "executor_param", "executor_block_strategy",
                            "executor_timeout", "executor_fail_retry_count", "glue_type", "glue_source",
                            "glue_remark", "glue_updatetime", "child_jobid", "trigger_status",
                            "trigger_last_time", "trigger_next_time")
VALUES (1, '测试任务1', '2018-11-03 22:21:31', '2018-11-03 22:21:31', 'XXL', '', 'CRON', '0 0 0 * * ? *',
        'DO_NOTHING', 'FIRST', 'demoJobHandler', '', 'SERIAL_EXECUTION', 0, 0, 'BEAN', '', 'GLUE代码初始化',
        '2018-11-03 22:21:31', '', 0, 0, 0);

INSERT INTO "xxl_job_lock" ("lock_name")
VALUES ('schedule_lock');

INSERT INTO "xxl_job_user" ("username", "password", "role", "permission")
VALUES ('admin', 'e10adc3949ba59abbe56e057f20f883e', 1, NULL);

COMMIT;

