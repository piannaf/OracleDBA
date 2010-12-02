/**************************************/
/* Part A -- INDEX_SIZE_TRACKING table*/
/**************************************/
CREATE TABLE "INDEX_SIZE_TRACKING" (
	"INDEX_NAME"		VARCHAR2(255),
	"ALLOCATED_SPACE"	NUMBER,
	"USED_SPACE"		NUMBER,
	"LAST_UPDATE"		VARCHAR2(255),
	CONSTRAINT "INDEX_SIZE_TRACKING_PK" PRIMARY KEY ("INDEX_NAME")
)
/