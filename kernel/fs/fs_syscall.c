/* This file use for NCTU OSDI course */


// It's handel the file system APIs 
#include <inc/stdio.h>
#include <inc/syscall.h>
#include <fs.h>

/*TODO: Lab7, file I/O system call interface.*/
/*Note: Here you need handle the file system call from user.
 *       1. When user open a new file, you can use the fd_new() to alloc a file object(struct fs_fd)
 *       2. When user R/W or seek the file, use the fd_get() to get file object.
 *       3. After get file object call file_* functions into VFS level
 *       4. Update the file objet's position or size when user R/W or seek the file.(You can find the useful marco in ff.h)
 *       5. Remember to use fd_put() to put file object back after user R/W, seek or close the file.
 *       6. Handle the error code, for example, if user call open() but no fd slot can be use, sys_open should return -STATUS_ENOSPC.
 *
 *  Call flow example:
 *        ┌──────────────┐
 *        │     open     │
 *        └──────────────┘
 *               ↓
 *        ╔══════════════╗
 *   ==>  ║   sys_open   ║  file I/O system call interface
 *        ╚══════════════╝
 *               ↓
 *        ┌──────────────┐
 *        │  file_open   │  VFS level file API
 *        └──────────────┘
 *               ↓
 *        ┌──────────────┐
 *        │   fat_open   │  fat level file operator
 *        └──────────────┘
 *               ↓
 *        ┌──────────────┐
 *        │    f_open    │  FAT File System Module
 *        └──────────────┘
 *               ↓
 *        ┌──────────────┐
 *        │    diskio    │  low level file operator
 *        └──────────────┘
 *               ↓
 *        ┌──────────────┐
 *        │     disk     │  simple ATA disk dirver
 *        └──────────────┘
 */
extern struct fs_fd fd_table[];
// Below is POSIX like I/O system call 
int sys_open(const char *file, int flags, int mode)
{
    //We dont care the mode.
/* TODO */
	int ret;
	struct fs_fd *new_fd;
	ret  = fd_new();
	if(!ret)
		return -STATUS_ENOSPC;
	new_fd = &fd_table[ret];
	file_open(new_fd,new_fd->path,new_fd->flags);
	
	return ret;
}

int sys_close(int fd)
{
/* TODO */
	int ret;
	struct fs_fd *close_fd;
	close_fd = fd_get(fd);
	ret =  file_close(close_fd);
	if(!ret)
		return -STATUS_ENOSPC;
	fd_put(close_fd);
	return ret;
	
}
int sys_read(int fd, void *buf, size_t len)
{
/* TODO */
	int ret ;
	struct fs_fd  *readfd;
	readfd = fd_get(fd);
	ret = file_read(readfd,buf,len);
	if(!ret)
		return -STATUS_ENOSPC;
	return ret;

}
int sys_write(int fd, const void *buf, size_t len)
{
/* TODO */
	int ret ;
	struct fs_fd  *writefd;
	writefd = fd_get(fd);
	ret = file_write(writefd,buf,len);
	if(!ret)
		return -STATUS_ENOSPC;
	return ret;
}

/* Note: Check the whence parameter and calcuate the new offset value before do file_seek() */
off_t sys_lseek(int fd, off_t offset, int whence)
{
/* TODO */
}

int sys_unlink(const char *pathname)
{
/* TODO */ 
}


              

