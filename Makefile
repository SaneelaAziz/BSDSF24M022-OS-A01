CC = gcc
CFLAGS = -Wall -Iinclude
PIC_FLAGS = -fPIC
AR = ar
ARFLAGS = rcs

# Directories
SRC_DIR = src
OBJ_DIR = obj
LIB_DIR = lib
BIN_DIR = bin

# Library Sources and Objects
LIB_SRCS = $(SRC_DIR)/mystrfunctions.c $(SRC_DIR)/myfilefunctions.c
STATIC_OBJS = $(OBJ_DIR)/mystrfunctions.o $(OBJ_DIR)/myfilefunctions.o
DYNAMIC_OBJS = $(OBJ_DIR)/mystrfunctions_pic.o $(OBJ_DIR)/myfilefunctions_pic.o

# Target Binaries & Libraries
STATIC_LIB = $(LIB_DIR)/libmyutils.a
DYNAMIC_LIB = $(LIB_DIR)/libmyutils.so

CLIENT_SRC = $(SRC_DIR)/main.c
STATIC_TARGET = $(BIN_DIR)/client_static
DYNAMIC_TARGET = $(BIN_DIR)/client_dynamic

# Default rule builds both static and dynamic targets
all: $(STATIC_TARGET) $(DYNAMIC_TARGET)

# --- Dynamic Library Rules ---

# Compile source files into Position-Independent Code (-fPIC) object files
$(OBJ_DIR)/%_pic.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) $(PIC_FLAGS) -c $< -o $@

# Link PIC object files into shared library (.so)
$(DYNAMIC_LIB): $(DYNAMIC_OBJS) | $(LIB_DIR)
	$(CC) -shared $^ -o $@

# Link client_dynamic against libmyutils.so
$(DYNAMIC_TARGET): $(CLIENT_SRC) $(DYNAMIC_LIB) | $(BIN_DIR)
	$(CC) $(CFLAGS) $(CLIENT_SRC) -L$(LIB_DIR) -lmyutils -o $@

# --- Static Library Rules ---

# Compile standard object files
$(OBJ_DIR)/%.o: $(SRC_DIR)/%.c | $(OBJ_DIR)
	$(CC) $(CFLAGS) -c $< -o $@

# Package object files into libmyutils.a
$(STATIC_LIB): $(STATIC_OBJS) | $(LIB_DIR)
	$(AR) $(ARFLAGS) $@ $^

# Link client_static against libmyutils.a
$(STATIC_TARGET): $(CLIENT_SRC) $(STATIC_LIB) | $(BIN_DIR)
	$(CC) $(CFLAGS) $(CLIENT_SRC) -L$(LIB_DIR) -lmyutils -o $@

# --- Directory Creation Rules ---
$(OBJ_DIR) $(LIB_DIR) $(BIN_DIR):
	mkdir -p $@

# Clean rule removes object files, static libraries, shared libraries, and binaries
clean:
	rm -rf $(OBJ_DIR)/*.o $(LIB_DIR)/*.a $(LIB_DIR)/*.so $(BIN_DIR)/*

.PHONY: all clean
