CC = gcc
CFLAGS = -Wall -Iinclude
AR = ar
ARFLAGS = rcs

# Directories
SRC_DIR = src
OBJ_DIR = obj
LIB_DIR = lib
BIN_DIR = bin

# Files based on your screenshot
LIB_SRCS = $(SRC_DIR)/mystrfunctions.c $(SRC_DIR)/myfilefunctions.c
LIB_OBJS = $(OBJ_DIR)/mystrfunctions.o $(OBJ_DIR)/myfilefunctions.o
STATIC_LIB = $(LIB_DIR)/libmyutils.a

CLIENT_SRC = $(SRC_DIR)/main.c
TARGET = $(BIN_DIR)/client_static

# Default rule
all: $(TARGET)

# Rule 1: Package object files into lib/libmyutils.a using ar
$(STATIC_LIB): $(LIB_OBJS) | $(LIB_DIR)
	$(AR) $(ARFLAGS) $@ $^

# Rule 2: Compile source files to obj/*.o
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Rule 3: Link client_static against libmyutils.a
$(TARGET): $(CLIENT_SRC) $(STATIC_LIB) | $(BIN_DIR)
	$(CC) $(CFLAGS) $(CLIENT_SRC) -L$(LIB_DIR) -lmyutils -o $@

# Directory creation rules
$(OBJ_DIR) $(LIB_DIR) $(BIN_DIR):
	mkdir -p $@

clean:
	rm -rf $(OBJ_DIR)/*.o $(LIB_DIR)/*.a $(BIN_DIR)/*

.PHONY: all clean
