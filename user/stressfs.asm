
stressfs:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "fs.h"
#include "fcntl.h"

int
main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	57                   	push   %edi
  12:	56                   	push   %esi
  13:	53                   	push   %ebx
  14:	51                   	push   %ecx
  15:	81 ec 20 02 00 00    	sub    $0x220,%esp
  int fd, i;
  char path[] = "stressfs0";
  1b:	8d 7d de             	lea    -0x22(%ebp),%edi
  1e:	be 87 05 00 00       	mov    $0x587,%esi
  23:	b9 0a 00 00 00       	mov    $0xa,%ecx
  28:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  char data[512];

  printf(1, "stressfs starting\n");
  2a:	68 64 05 00 00       	push   $0x564
  2f:	6a 01                	push   $0x1
  31:	e8 d1 03 00 00       	call   407 <printf>
  memset(data, 'a', sizeof(data));
  36:	83 c4 0c             	add    $0xc,%esp
  39:	68 00 02 00 00       	push   $0x200
  3e:	6a 61                	push   $0x61
  40:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  46:	50                   	push   %eax
  47:	e8 3f 01 00 00       	call   18b <memset>

  for(i = 0; i < 4; i++)
  4c:	83 c4 10             	add    $0x10,%esp
  4f:	bb 00 00 00 00       	mov    $0x0,%ebx
  54:	83 fb 03             	cmp    $0x3,%ebx
  57:	7f 0c                	jg     65 <main+0x65>
    if(fork() > 0)
  59:	e8 62 02 00 00       	call   2c0 <fork>
  5e:	85 c0                	test   %eax,%eax
  60:	7f 03                	jg     65 <main+0x65>
  for(i = 0; i < 4; i++)
  62:	43                   	inc    %ebx
  63:	eb ef                	jmp    54 <main+0x54>
      break;

  printf(1, "write %d\n", i);
  65:	83 ec 04             	sub    $0x4,%esp
  68:	53                   	push   %ebx
  69:	68 77 05 00 00       	push   $0x577
  6e:	6a 01                	push   $0x1
  70:	e8 92 03 00 00       	call   407 <printf>

  path[8] += i;
  75:	00 5d e6             	add    %bl,-0x1a(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
  78:	83 c4 08             	add    $0x8,%esp
  7b:	68 02 02 00 00       	push   $0x202
  80:	8d 45 de             	lea    -0x22(%ebp),%eax
  83:	50                   	push   %eax
  84:	e8 7f 02 00 00       	call   308 <open>
  89:	89 c6                	mov    %eax,%esi
  for(i = 0; i < 20; i++)
  8b:	83 c4 10             	add    $0x10,%esp
  8e:	bb 00 00 00 00       	mov    $0x0,%ebx
  93:	eb 19                	jmp    ae <main+0xae>
//    printf(fd, "%d\n", i);
    write(fd, data, sizeof(data));
  95:	83 ec 04             	sub    $0x4,%esp
  98:	68 00 02 00 00       	push   $0x200
  9d:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  a3:	50                   	push   %eax
  a4:	56                   	push   %esi
  a5:	e8 3e 02 00 00       	call   2e8 <write>
  for(i = 0; i < 20; i++)
  aa:	43                   	inc    %ebx
  ab:	83 c4 10             	add    $0x10,%esp
  ae:	83 fb 13             	cmp    $0x13,%ebx
  b1:	7e e2                	jle    95 <main+0x95>
  close(fd);
  b3:	83 ec 0c             	sub    $0xc,%esp
  b6:	56                   	push   %esi
  b7:	e8 34 02 00 00       	call   2f0 <close>

  printf(1, "read\n");
  bc:	83 c4 08             	add    $0x8,%esp
  bf:	68 81 05 00 00       	push   $0x581
  c4:	6a 01                	push   $0x1
  c6:	e8 3c 03 00 00       	call   407 <printf>

  fd = open(path, O_RDONLY);
  cb:	83 c4 08             	add    $0x8,%esp
  ce:	6a 00                	push   $0x0
  d0:	8d 45 de             	lea    -0x22(%ebp),%eax
  d3:	50                   	push   %eax
  d4:	e8 2f 02 00 00       	call   308 <open>
  d9:	89 c6                	mov    %eax,%esi
  for (i = 0; i < 20; i++)
  db:	83 c4 10             	add    $0x10,%esp
  de:	bb 00 00 00 00       	mov    $0x0,%ebx
  e3:	eb 19                	jmp    fe <main+0xfe>
    read(fd, data, sizeof(data));
  e5:	83 ec 04             	sub    $0x4,%esp
  e8:	68 00 02 00 00       	push   $0x200
  ed:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  f3:	50                   	push   %eax
  f4:	56                   	push   %esi
  f5:	e8 e6 01 00 00       	call   2e0 <read>
  for (i = 0; i < 20; i++)
  fa:	43                   	inc    %ebx
  fb:	83 c4 10             	add    $0x10,%esp
  fe:	83 fb 13             	cmp    $0x13,%ebx
 101:	7e e2                	jle    e5 <main+0xe5>
  close(fd);
 103:	83 ec 0c             	sub    $0xc,%esp
 106:	56                   	push   %esi
 107:	e8 e4 01 00 00       	call   2f0 <close>

  wait(NULL);
 10c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 113:	e8 b8 01 00 00       	call   2d0 <wait>

  exit(0);
 118:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
 11f:	e8 a4 01 00 00       	call   2c8 <exit>

00000124 <start>:
#include <x86.h>

// Entry point of the library	
void
start()
{
 124:	f3 0f 1e fb          	endbr32 
}
 128:	c3                   	ret    

00000129 <strcpy>:

char*
strcpy(char *s, const char *t)
{
 129:	f3 0f 1e fb          	endbr32 
 12d:	55                   	push   %ebp
 12e:	89 e5                	mov    %esp,%ebp
 130:	56                   	push   %esi
 131:	53                   	push   %ebx
 132:	8b 45 08             	mov    0x8(%ebp),%eax
 135:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 138:	89 c2                	mov    %eax,%edx
 13a:	89 cb                	mov    %ecx,%ebx
 13c:	41                   	inc    %ecx
 13d:	89 d6                	mov    %edx,%esi
 13f:	42                   	inc    %edx
 140:	8a 1b                	mov    (%ebx),%bl
 142:	88 1e                	mov    %bl,(%esi)
 144:	84 db                	test   %bl,%bl
 146:	75 f2                	jne    13a <strcpy+0x11>
    ;
  return os;
}
 148:	5b                   	pop    %ebx
 149:	5e                   	pop    %esi
 14a:	5d                   	pop    %ebp
 14b:	c3                   	ret    

0000014c <strcmp>:

int
strcmp(const char *p, const char *q)
{
 14c:	f3 0f 1e fb          	endbr32 
 150:	55                   	push   %ebp
 151:	89 e5                	mov    %esp,%ebp
 153:	8b 4d 08             	mov    0x8(%ebp),%ecx
 156:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 159:	8a 01                	mov    (%ecx),%al
 15b:	84 c0                	test   %al,%al
 15d:	74 08                	je     167 <strcmp+0x1b>
 15f:	3a 02                	cmp    (%edx),%al
 161:	75 04                	jne    167 <strcmp+0x1b>
    p++, q++;
 163:	41                   	inc    %ecx
 164:	42                   	inc    %edx
 165:	eb f2                	jmp    159 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 167:	0f b6 c0             	movzbl %al,%eax
 16a:	0f b6 12             	movzbl (%edx),%edx
 16d:	29 d0                	sub    %edx,%eax
}
 16f:	5d                   	pop    %ebp
 170:	c3                   	ret    

00000171 <strlen>:

uint
strlen(const char *s)
{
 171:	f3 0f 1e fb          	endbr32 
 175:	55                   	push   %ebp
 176:	89 e5                	mov    %esp,%ebp
 178:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 17b:	b8 00 00 00 00       	mov    $0x0,%eax
 180:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 184:	74 03                	je     189 <strlen+0x18>
 186:	40                   	inc    %eax
 187:	eb f7                	jmp    180 <strlen+0xf>
    ;
  return n;
}
 189:	5d                   	pop    %ebp
 18a:	c3                   	ret    

0000018b <memset>:

void*
memset(void *dst, int c, uint n)
{
 18b:	f3 0f 1e fb          	endbr32 
 18f:	55                   	push   %ebp
 190:	89 e5                	mov    %esp,%ebp
 192:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 193:	8b 7d 08             	mov    0x8(%ebp),%edi
 196:	8b 4d 10             	mov    0x10(%ebp),%ecx
 199:	8b 45 0c             	mov    0xc(%ebp),%eax
 19c:	fc                   	cld    
 19d:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 19f:	8b 45 08             	mov    0x8(%ebp),%eax
 1a2:	5f                   	pop    %edi
 1a3:	5d                   	pop    %ebp
 1a4:	c3                   	ret    

000001a5 <strchr>:

char*
strchr(const char *s, char c)
{
 1a5:	f3 0f 1e fb          	endbr32 
 1a9:	55                   	push   %ebp
 1aa:	89 e5                	mov    %esp,%ebp
 1ac:	8b 45 08             	mov    0x8(%ebp),%eax
 1af:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 1b2:	8a 10                	mov    (%eax),%dl
 1b4:	84 d2                	test   %dl,%dl
 1b6:	74 07                	je     1bf <strchr+0x1a>
    if(*s == c)
 1b8:	38 ca                	cmp    %cl,%dl
 1ba:	74 08                	je     1c4 <strchr+0x1f>
  for(; *s; s++)
 1bc:	40                   	inc    %eax
 1bd:	eb f3                	jmp    1b2 <strchr+0xd>
      return (char*)s;
  return 0;
 1bf:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1c4:	5d                   	pop    %ebp
 1c5:	c3                   	ret    

000001c6 <gets>:

char*
gets(char *buf, int max)
{
 1c6:	f3 0f 1e fb          	endbr32 
 1ca:	55                   	push   %ebp
 1cb:	89 e5                	mov    %esp,%ebp
 1cd:	57                   	push   %edi
 1ce:	56                   	push   %esi
 1cf:	53                   	push   %ebx
 1d0:	83 ec 1c             	sub    $0x1c,%esp
 1d3:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1d6:	bb 00 00 00 00       	mov    $0x0,%ebx
 1db:	89 de                	mov    %ebx,%esi
 1dd:	43                   	inc    %ebx
 1de:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1e1:	7d 2b                	jge    20e <gets+0x48>
    cc = read(0, &c, 1);
 1e3:	83 ec 04             	sub    $0x4,%esp
 1e6:	6a 01                	push   $0x1
 1e8:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1eb:	50                   	push   %eax
 1ec:	6a 00                	push   $0x0
 1ee:	e8 ed 00 00 00       	call   2e0 <read>
    if(cc < 1)
 1f3:	83 c4 10             	add    $0x10,%esp
 1f6:	85 c0                	test   %eax,%eax
 1f8:	7e 14                	jle    20e <gets+0x48>
      break;
    buf[i++] = c;
 1fa:	8a 45 e7             	mov    -0x19(%ebp),%al
 1fd:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 200:	3c 0a                	cmp    $0xa,%al
 202:	74 08                	je     20c <gets+0x46>
 204:	3c 0d                	cmp    $0xd,%al
 206:	75 d3                	jne    1db <gets+0x15>
    buf[i++] = c;
 208:	89 de                	mov    %ebx,%esi
 20a:	eb 02                	jmp    20e <gets+0x48>
 20c:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 20e:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 212:	89 f8                	mov    %edi,%eax
 214:	8d 65 f4             	lea    -0xc(%ebp),%esp
 217:	5b                   	pop    %ebx
 218:	5e                   	pop    %esi
 219:	5f                   	pop    %edi
 21a:	5d                   	pop    %ebp
 21b:	c3                   	ret    

0000021c <stat>:

int
stat(const char *n, struct stat *st)
{
 21c:	f3 0f 1e fb          	endbr32 
 220:	55                   	push   %ebp
 221:	89 e5                	mov    %esp,%ebp
 223:	56                   	push   %esi
 224:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 225:	83 ec 08             	sub    $0x8,%esp
 228:	6a 00                	push   $0x0
 22a:	ff 75 08             	pushl  0x8(%ebp)
 22d:	e8 d6 00 00 00       	call   308 <open>
  if(fd < 0)
 232:	83 c4 10             	add    $0x10,%esp
 235:	85 c0                	test   %eax,%eax
 237:	78 24                	js     25d <stat+0x41>
 239:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 23b:	83 ec 08             	sub    $0x8,%esp
 23e:	ff 75 0c             	pushl  0xc(%ebp)
 241:	50                   	push   %eax
 242:	e8 d9 00 00 00       	call   320 <fstat>
 247:	89 c6                	mov    %eax,%esi
  close(fd);
 249:	89 1c 24             	mov    %ebx,(%esp)
 24c:	e8 9f 00 00 00       	call   2f0 <close>
  return r;
 251:	83 c4 10             	add    $0x10,%esp
}
 254:	89 f0                	mov    %esi,%eax
 256:	8d 65 f8             	lea    -0x8(%ebp),%esp
 259:	5b                   	pop    %ebx
 25a:	5e                   	pop    %esi
 25b:	5d                   	pop    %ebp
 25c:	c3                   	ret    
    return -1;
 25d:	be ff ff ff ff       	mov    $0xffffffff,%esi
 262:	eb f0                	jmp    254 <stat+0x38>

00000264 <atoi>:

int
atoi(const char *s)
{
 264:	f3 0f 1e fb          	endbr32 
 268:	55                   	push   %ebp
 269:	89 e5                	mov    %esp,%ebp
 26b:	53                   	push   %ebx
 26c:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 26f:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 274:	8a 01                	mov    (%ecx),%al
 276:	8d 58 d0             	lea    -0x30(%eax),%ebx
 279:	80 fb 09             	cmp    $0x9,%bl
 27c:	77 10                	ja     28e <atoi+0x2a>
    n = n*10 + *s++ - '0';
 27e:	8d 14 92             	lea    (%edx,%edx,4),%edx
 281:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 284:	41                   	inc    %ecx
 285:	0f be c0             	movsbl %al,%eax
 288:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
 28c:	eb e6                	jmp    274 <atoi+0x10>
  return n;
}
 28e:	89 d0                	mov    %edx,%eax
 290:	5b                   	pop    %ebx
 291:	5d                   	pop    %ebp
 292:	c3                   	ret    

00000293 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 293:	f3 0f 1e fb          	endbr32 
 297:	55                   	push   %ebp
 298:	89 e5                	mov    %esp,%ebp
 29a:	56                   	push   %esi
 29b:	53                   	push   %ebx
 29c:	8b 45 08             	mov    0x8(%ebp),%eax
 29f:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 2a2:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 2a5:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 2a7:	8d 72 ff             	lea    -0x1(%edx),%esi
 2aa:	85 d2                	test   %edx,%edx
 2ac:	7e 0e                	jle    2bc <memmove+0x29>
    *dst++ = *src++;
 2ae:	8a 13                	mov    (%ebx),%dl
 2b0:	88 11                	mov    %dl,(%ecx)
 2b2:	8d 5b 01             	lea    0x1(%ebx),%ebx
 2b5:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 2b8:	89 f2                	mov    %esi,%edx
 2ba:	eb eb                	jmp    2a7 <memmove+0x14>
  return vdst;
}
 2bc:	5b                   	pop    %ebx
 2bd:	5e                   	pop    %esi
 2be:	5d                   	pop    %ebp
 2bf:	c3                   	ret    

000002c0 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2c0:	b8 01 00 00 00       	mov    $0x1,%eax
 2c5:	cd 40                	int    $0x40
 2c7:	c3                   	ret    

000002c8 <exit>:
SYSCALL(exit)
 2c8:	b8 02 00 00 00       	mov    $0x2,%eax
 2cd:	cd 40                	int    $0x40
 2cf:	c3                   	ret    

000002d0 <wait>:
SYSCALL(wait)
 2d0:	b8 03 00 00 00       	mov    $0x3,%eax
 2d5:	cd 40                	int    $0x40
 2d7:	c3                   	ret    

000002d8 <pipe>:
SYSCALL(pipe)
 2d8:	b8 04 00 00 00       	mov    $0x4,%eax
 2dd:	cd 40                	int    $0x40
 2df:	c3                   	ret    

000002e0 <read>:
SYSCALL(read)
 2e0:	b8 05 00 00 00       	mov    $0x5,%eax
 2e5:	cd 40                	int    $0x40
 2e7:	c3                   	ret    

000002e8 <write>:
SYSCALL(write)
 2e8:	b8 10 00 00 00       	mov    $0x10,%eax
 2ed:	cd 40                	int    $0x40
 2ef:	c3                   	ret    

000002f0 <close>:
SYSCALL(close)
 2f0:	b8 15 00 00 00       	mov    $0x15,%eax
 2f5:	cd 40                	int    $0x40
 2f7:	c3                   	ret    

000002f8 <kill>:
SYSCALL(kill)
 2f8:	b8 06 00 00 00       	mov    $0x6,%eax
 2fd:	cd 40                	int    $0x40
 2ff:	c3                   	ret    

00000300 <exec>:
SYSCALL(exec)
 300:	b8 07 00 00 00       	mov    $0x7,%eax
 305:	cd 40                	int    $0x40
 307:	c3                   	ret    

00000308 <open>:
SYSCALL(open)
 308:	b8 0f 00 00 00       	mov    $0xf,%eax
 30d:	cd 40                	int    $0x40
 30f:	c3                   	ret    

00000310 <mknod>:
SYSCALL(mknod)
 310:	b8 11 00 00 00       	mov    $0x11,%eax
 315:	cd 40                	int    $0x40
 317:	c3                   	ret    

00000318 <unlink>:
SYSCALL(unlink)
 318:	b8 12 00 00 00       	mov    $0x12,%eax
 31d:	cd 40                	int    $0x40
 31f:	c3                   	ret    

00000320 <fstat>:
SYSCALL(fstat)
 320:	b8 08 00 00 00       	mov    $0x8,%eax
 325:	cd 40                	int    $0x40
 327:	c3                   	ret    

00000328 <link>:
SYSCALL(link)
 328:	b8 13 00 00 00       	mov    $0x13,%eax
 32d:	cd 40                	int    $0x40
 32f:	c3                   	ret    

00000330 <mkdir>:
SYSCALL(mkdir)
 330:	b8 14 00 00 00       	mov    $0x14,%eax
 335:	cd 40                	int    $0x40
 337:	c3                   	ret    

00000338 <chdir>:
SYSCALL(chdir)
 338:	b8 09 00 00 00       	mov    $0x9,%eax
 33d:	cd 40                	int    $0x40
 33f:	c3                   	ret    

00000340 <dup>:
SYSCALL(dup)
 340:	b8 0a 00 00 00       	mov    $0xa,%eax
 345:	cd 40                	int    $0x40
 347:	c3                   	ret    

00000348 <getpid>:
SYSCALL(getpid)
 348:	b8 0b 00 00 00       	mov    $0xb,%eax
 34d:	cd 40                	int    $0x40
 34f:	c3                   	ret    

00000350 <sbrk>:
SYSCALL(sbrk)
 350:	b8 0c 00 00 00       	mov    $0xc,%eax
 355:	cd 40                	int    $0x40
 357:	c3                   	ret    

00000358 <sleep>:
SYSCALL(sleep)
 358:	b8 0d 00 00 00       	mov    $0xd,%eax
 35d:	cd 40                	int    $0x40
 35f:	c3                   	ret    

00000360 <uptime>:
SYSCALL(uptime)
 360:	b8 0e 00 00 00       	mov    $0xe,%eax
 365:	cd 40                	int    $0x40
 367:	c3                   	ret    

00000368 <date>:
SYSCALL(date)
 368:	b8 16 00 00 00       	mov    $0x16,%eax
 36d:	cd 40                	int    $0x40
 36f:	c3                   	ret    

00000370 <dup2>:
 370:	b8 17 00 00 00       	mov    $0x17,%eax
 375:	cd 40                	int    $0x40
 377:	c3                   	ret    

00000378 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 378:	55                   	push   %ebp
 379:	89 e5                	mov    %esp,%ebp
 37b:	83 ec 1c             	sub    $0x1c,%esp
 37e:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 381:	6a 01                	push   $0x1
 383:	8d 55 f4             	lea    -0xc(%ebp),%edx
 386:	52                   	push   %edx
 387:	50                   	push   %eax
 388:	e8 5b ff ff ff       	call   2e8 <write>
}
 38d:	83 c4 10             	add    $0x10,%esp
 390:	c9                   	leave  
 391:	c3                   	ret    

00000392 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 392:	55                   	push   %ebp
 393:	89 e5                	mov    %esp,%ebp
 395:	57                   	push   %edi
 396:	56                   	push   %esi
 397:	53                   	push   %ebx
 398:	83 ec 2c             	sub    $0x2c,%esp
 39b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 39e:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 3a0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 3a4:	74 04                	je     3aa <printint+0x18>
 3a6:	85 d2                	test   %edx,%edx
 3a8:	78 3a                	js     3e4 <printint+0x52>
  neg = 0;
 3aa:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 3b1:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 3b6:	89 f0                	mov    %esi,%eax
 3b8:	ba 00 00 00 00       	mov    $0x0,%edx
 3bd:	f7 f1                	div    %ecx
 3bf:	89 df                	mov    %ebx,%edi
 3c1:	43                   	inc    %ebx
 3c2:	8a 92 98 05 00 00    	mov    0x598(%edx),%dl
 3c8:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3cc:	89 f2                	mov    %esi,%edx
 3ce:	89 c6                	mov    %eax,%esi
 3d0:	39 d1                	cmp    %edx,%ecx
 3d2:	76 e2                	jbe    3b6 <printint+0x24>
  if(neg)
 3d4:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 3d8:	74 22                	je     3fc <printint+0x6a>
    buf[i++] = '-';
 3da:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3df:	8d 5f 02             	lea    0x2(%edi),%ebx
 3e2:	eb 18                	jmp    3fc <printint+0x6a>
    x = -xx;
 3e4:	f7 de                	neg    %esi
    neg = 1;
 3e6:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 3ed:	eb c2                	jmp    3b1 <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 3ef:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 3f4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 3f7:	e8 7c ff ff ff       	call   378 <putc>
  while(--i >= 0)
 3fc:	4b                   	dec    %ebx
 3fd:	79 f0                	jns    3ef <printint+0x5d>
}
 3ff:	83 c4 2c             	add    $0x2c,%esp
 402:	5b                   	pop    %ebx
 403:	5e                   	pop    %esi
 404:	5f                   	pop    %edi
 405:	5d                   	pop    %ebp
 406:	c3                   	ret    

00000407 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 407:	f3 0f 1e fb          	endbr32 
 40b:	55                   	push   %ebp
 40c:	89 e5                	mov    %esp,%ebp
 40e:	57                   	push   %edi
 40f:	56                   	push   %esi
 410:	53                   	push   %ebx
 411:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 414:	8d 45 10             	lea    0x10(%ebp),%eax
 417:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 41a:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 41f:	bb 00 00 00 00       	mov    $0x0,%ebx
 424:	eb 12                	jmp    438 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 426:	89 fa                	mov    %edi,%edx
 428:	8b 45 08             	mov    0x8(%ebp),%eax
 42b:	e8 48 ff ff ff       	call   378 <putc>
 430:	eb 05                	jmp    437 <printf+0x30>
      }
    } else if(state == '%'){
 432:	83 fe 25             	cmp    $0x25,%esi
 435:	74 22                	je     459 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 437:	43                   	inc    %ebx
 438:	8b 45 0c             	mov    0xc(%ebp),%eax
 43b:	8a 04 18             	mov    (%eax,%ebx,1),%al
 43e:	84 c0                	test   %al,%al
 440:	0f 84 13 01 00 00    	je     559 <printf+0x152>
    c = fmt[i] & 0xff;
 446:	0f be f8             	movsbl %al,%edi
 449:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 44c:	85 f6                	test   %esi,%esi
 44e:	75 e2                	jne    432 <printf+0x2b>
      if(c == '%'){
 450:	83 f8 25             	cmp    $0x25,%eax
 453:	75 d1                	jne    426 <printf+0x1f>
        state = '%';
 455:	89 c6                	mov    %eax,%esi
 457:	eb de                	jmp    437 <printf+0x30>
      if(c == 'd'){
 459:	83 f8 64             	cmp    $0x64,%eax
 45c:	74 43                	je     4a1 <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 45e:	83 f8 78             	cmp    $0x78,%eax
 461:	74 68                	je     4cb <printf+0xc4>
 463:	83 f8 70             	cmp    $0x70,%eax
 466:	74 63                	je     4cb <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 468:	83 f8 73             	cmp    $0x73,%eax
 46b:	0f 84 84 00 00 00    	je     4f5 <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 471:	83 f8 63             	cmp    $0x63,%eax
 474:	0f 84 ad 00 00 00    	je     527 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 47a:	83 f8 25             	cmp    $0x25,%eax
 47d:	0f 84 c2 00 00 00    	je     545 <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 483:	ba 25 00 00 00       	mov    $0x25,%edx
 488:	8b 45 08             	mov    0x8(%ebp),%eax
 48b:	e8 e8 fe ff ff       	call   378 <putc>
        putc(fd, c);
 490:	89 fa                	mov    %edi,%edx
 492:	8b 45 08             	mov    0x8(%ebp),%eax
 495:	e8 de fe ff ff       	call   378 <putc>
      }
      state = 0;
 49a:	be 00 00 00 00       	mov    $0x0,%esi
 49f:	eb 96                	jmp    437 <printf+0x30>
        printint(fd, *ap, 10, 1);
 4a1:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4a4:	8b 17                	mov    (%edi),%edx
 4a6:	83 ec 0c             	sub    $0xc,%esp
 4a9:	6a 01                	push   $0x1
 4ab:	b9 0a 00 00 00       	mov    $0xa,%ecx
 4b0:	8b 45 08             	mov    0x8(%ebp),%eax
 4b3:	e8 da fe ff ff       	call   392 <printint>
        ap++;
 4b8:	83 c7 04             	add    $0x4,%edi
 4bb:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4be:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4c1:	be 00 00 00 00       	mov    $0x0,%esi
 4c6:	e9 6c ff ff ff       	jmp    437 <printf+0x30>
        printint(fd, *ap, 16, 0);
 4cb:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4ce:	8b 17                	mov    (%edi),%edx
 4d0:	83 ec 0c             	sub    $0xc,%esp
 4d3:	6a 00                	push   $0x0
 4d5:	b9 10 00 00 00       	mov    $0x10,%ecx
 4da:	8b 45 08             	mov    0x8(%ebp),%eax
 4dd:	e8 b0 fe ff ff       	call   392 <printint>
        ap++;
 4e2:	83 c7 04             	add    $0x4,%edi
 4e5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4e8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4eb:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 4f0:	e9 42 ff ff ff       	jmp    437 <printf+0x30>
        s = (char*)*ap;
 4f5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4f8:	8b 30                	mov    (%eax),%esi
        ap++;
 4fa:	83 c0 04             	add    $0x4,%eax
 4fd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 500:	85 f6                	test   %esi,%esi
 502:	75 13                	jne    517 <printf+0x110>
          s = "(null)";
 504:	be 91 05 00 00       	mov    $0x591,%esi
 509:	eb 0c                	jmp    517 <printf+0x110>
          putc(fd, *s);
 50b:	0f be d2             	movsbl %dl,%edx
 50e:	8b 45 08             	mov    0x8(%ebp),%eax
 511:	e8 62 fe ff ff       	call   378 <putc>
          s++;
 516:	46                   	inc    %esi
        while(*s != 0){
 517:	8a 16                	mov    (%esi),%dl
 519:	84 d2                	test   %dl,%dl
 51b:	75 ee                	jne    50b <printf+0x104>
      state = 0;
 51d:	be 00 00 00 00       	mov    $0x0,%esi
 522:	e9 10 ff ff ff       	jmp    437 <printf+0x30>
        putc(fd, *ap);
 527:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 52a:	0f be 17             	movsbl (%edi),%edx
 52d:	8b 45 08             	mov    0x8(%ebp),%eax
 530:	e8 43 fe ff ff       	call   378 <putc>
        ap++;
 535:	83 c7 04             	add    $0x4,%edi
 538:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 53b:	be 00 00 00 00       	mov    $0x0,%esi
 540:	e9 f2 fe ff ff       	jmp    437 <printf+0x30>
        putc(fd, c);
 545:	89 fa                	mov    %edi,%edx
 547:	8b 45 08             	mov    0x8(%ebp),%eax
 54a:	e8 29 fe ff ff       	call   378 <putc>
      state = 0;
 54f:	be 00 00 00 00       	mov    $0x0,%esi
 554:	e9 de fe ff ff       	jmp    437 <printf+0x30>
    }
  }
}
 559:	8d 65 f4             	lea    -0xc(%ebp),%esp
 55c:	5b                   	pop    %ebx
 55d:	5e                   	pop    %esi
 55e:	5f                   	pop    %edi
 55f:	5d                   	pop    %ebp
 560:	c3                   	ret    
