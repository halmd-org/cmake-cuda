IF(EXISTS "${MARK_FILE}")
  MESSAGE(FATAL_ERROR "Custom command run more than once!")
ELSE(EXISTS "${MARK_FILE}")
  FILE(WRITE "${MARK_FILE}" "check for running custom command twice\n")
ENDIF(EXISTS "${MARK_FILE}")
