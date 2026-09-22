# 1. Compiler and Archiver Configuration
CC = gcc
CFLAGS = -Wall -Iinclude
AR = ar
ARFLAGS = rcs

# 2. Directory Definitions
SRC_DIR = src
LIB_DIR = lib
BIN_DIR = bin
INC_DIR = include

# 3. File Lists
# Utility sources that will go into the static library
LIB_SRCS = $(SRC_DIR)/string_utils.c $(SRC_DIR)/file_utils.c
LIB_OBJS = $(SRC_DIR)/string_utils.o $(SRC_DIR)/file_utils.o
STATIC_LIB = $(LIB_DIR)/libmyutils.a

# Client driver file and final output executable
CLIENT_SRC = $(SRC_DIR)/main.c
TARGET = $(BIN_DIR)/client_static

# Default rule
all: $(TARGET)

# 4. Rule to build the Static Library (lib/libmyutils.a)
$(STATIC_LIB): $(LIB_OBJS) | $(LIB_DIR)
	$(AR) $(ARFLAGS) $@ $^

# 5. Generic pattern rule to compile source files into object files
$(SRC_DIR)/%.o: $(SRC_DIR)/%.c
	$(CC) $(CFLAGS) -c $< -o $@

# 6. Rule to compile and link client_static against libmyutils.a
$(TARGET): $(CLIENT_SRC) $(STATIC_LIB) | $(BIN_DIR)
	$(CC) $(CFLAGS) $(CLIENT_SRC) -L$(LIB_DIR) -lmyutils -o $@

# Rule to create output directories if they don't exist
$(LIB_DIR) $(BIN_DIR):
	mkdir -p $@

# Clean rule to clear built binaries and library files
clean:
	rm -f $(SRC_DIR)/*.o $(STATIC_LIB) $(TARGET)

.PHONY: all clean
