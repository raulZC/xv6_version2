
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
  1e:	be 6f 05 00 00       	mov    $0x56f,%esi
  23:	b9 0a 00 00 00       	mov    $0xa,%ecx
  28:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  char data[512];

  printf(1, "stressfs starting\n");
  2a:	68 4c 05 00 00       	push   $0x54c
  2f:	6a 01                	push   $0x1
  31:	e8 bb 03 00 00       	call   3f1 <printf>
  memset(data, 'a', sizeof(data));
  36:	83 c4 0c             	add    $0xc,%esp
  39:	68 00 02 00 00       	push   $0x200
  3e:	6a 61                	push   $0x61
  40:	8d 85 de fd ff ff    	lea    -0x222(%ebp),%eax
  46:	50                   	push   %eax
  47:	e8 31 01 00 00       	call   17d <memset>

  for(i = 0; i < 4; i++)
  4c:	83 c4 10             	add    $0x10,%esp
  4f:	bb 00 00 00 00       	mov    $0x0,%ebx
  54:	83 fb 03             	cmp    $0x3,%ebx
  57:	7f 0c                	jg     65 <main+0x65>
    if(fork() > 0)
  59:	e8 54 02 00 00       	call   2b2 <fork>
  5e:	85 c0                	test   %eax,%eax
  60:	7f 03                	jg     65 <main+0x65>
  for(i = 0; i < 4; i++)
  62:	43                   	inc    %ebx
  63:	eb ef                	jmp    54 <main+0x54>
      break;

  printf(1, "write %d\n", i);
  65:	83 ec 04             	sub    $0x4,%esp
  68:	53                   	push   %ebx
  69:	68 5f 05 00 00       	push   $0x55f
  6e:	6a 01                	push   $0x1
  70:	e8 7c 03 00 00       	call   3f1 <printf>

  path[8] += i;
  75:	00 5d e6             	add    %bl,-0x1a(%ebp)
  fd = open(path, O_CREATE | O_RDWR);
  78:	83 c4 08             	add    $0x8,%esp
  7b:	68 02 02 00 00       	push   $0x202
  80:	8d 45 de             	lea    -0x22(%ebp),%eax
  83:	50                   	push   %eax
  84:	e8 71 02 00 00       	call   2fa <open>
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
  a5:	e8 30 02 00 00       	call   2da <write>
  for(i = 0; i < 20; i++)
  aa:	43                   	inc    %ebx
  ab:	83 c4 10             	add    $0x10,%esp
  ae:	83 fb 13             	cmp    $0x13,%ebx
  b1:	7e e2                	jle    95 <main+0x95>
  close(fd);
  b3:	83 ec 0c             	sub    $0xc,%esp
  b6:	56                   	push   %esi
  b7:	e8 26 02 00 00       	call   2e2 <close>

  printf(1, "read\n");
  bc:	83 c4 08             	add    $0x8,%esp
  bf:	68 69 05 00 00       	push   $0x569
  c4:	6a 01                	push   $0x1
  c6:	e8 26 03 00 00       	call   3f1 <printf>

  fd = open(path, O_RDONLY);
  cb:	83 c4 08             	add    $0x8,%esp
  ce:	6a 00                	push   $0x0
  d0:	8d 45 de             	lea    -0x22(%ebp),%eax
  d3:	50                   	push   %eax
  d4:	e8 21 02 00 00       	call   2fa <open>
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
  f5:	e8 d8 01 00 00       	call   2d2 <read>
  for (i = 0; i < 20; i++)
  fa:	43                   	inc    %ebx
  fb:	83 c4 10             	add    $0x10,%esp
  fe:	83 fb 13             	cmp    $0x13,%ebx
 101:	7e e2                	jle    e5 <main+0xe5>
  close(fd);
 103:	83 ec 0c             	sub    $0xc,%esp
 106:	56                   	push   %esi
 107:	e8 d6 01 00 00       	call   2e2 <close>

  wait();
 10c:	e8 b1 01 00 00       	call   2c2 <wait>

  exit();
 111:	e8 a4 01 00 00       	call   2ba <exit>

00000116 <start>:
#include <x86.h>

// Entry point of the library	
void
start()
{
 116:	f3 0f 1e fb          	endbr32 
}
 11a:	c3                   	ret    

0000011b <strcpy>:

char*
strcpy(char *s, const char *t)
{
 11b:	f3 0f 1e fb          	endbr32 
 11f:	55                   	push   %ebp
 120:	89 e5                	mov    %esp,%ebp
 122:	56                   	push   %esi
 123:	53                   	push   %ebx
 124:	8b 45 08             	mov    0x8(%ebp),%eax
 127:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 12a:	89 c2                	mov    %eax,%edx
 12c:	89 cb                	mov    %ecx,%ebx
 12e:	41                   	inc    %ecx
 12f:	89 d6                	mov    %edx,%esi
 131:	42                   	inc    %edx
 132:	8a 1b                	mov    (%ebx),%bl
 134:	88 1e                	mov    %bl,(%esi)
 136:	84 db                	test   %bl,%bl
 138:	75 f2                	jne    12c <strcpy+0x11>
    ;
  return os;
}
 13a:	5b                   	pop    %ebx
 13b:	5e                   	pop    %esi
 13c:	5d                   	pop    %ebp
 13d:	c3                   	ret    

0000013e <strcmp>:

int
strcmp(const char *p, const char *q)
{
 13e:	f3 0f 1e fb          	endbr32 
 142:	55                   	push   %ebp
 143:	89 e5                	mov    %esp,%ebp
 145:	8b 4d 08             	mov    0x8(%ebp),%ecx
 148:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 14b:	8a 01                	mov    (%ecx),%al
 14d:	84 c0                	test   %al,%al
 14f:	74 08                	je     159 <strcmp+0x1b>
 151:	3a 02                	cmp    (%edx),%al
 153:	75 04                	jne    159 <strcmp+0x1b>
    p++, q++;
 155:	41                   	inc    %ecx
 156:	42                   	inc    %edx
 157:	eb f2                	jmp    14b <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 159:	0f b6 c0             	movzbl %al,%eax
 15c:	0f b6 12             	movzbl (%edx),%edx
 15f:	29 d0                	sub    %edx,%eax
}
 161:	5d                   	pop    %ebp
 162:	c3                   	ret    

00000163 <strlen>:

uint
strlen(const char *s)
{
 163:	f3 0f 1e fb          	endbr32 
 167:	55                   	push   %ebp
 168:	89 e5                	mov    %esp,%ebp
 16a:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 16d:	b8 00 00 00 00       	mov    $0x0,%eax
 172:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 176:	74 03                	je     17b <strlen+0x18>
 178:	40                   	inc    %eax
 179:	eb f7                	jmp    172 <strlen+0xf>
    ;
  return n;
}
 17b:	5d                   	pop    %ebp
 17c:	c3                   	ret    

0000017d <memset>:

void*
memset(void *dst, int c, uint n)
{
 17d:	f3 0f 1e fb          	endbr32 
 181:	55                   	push   %ebp
 182:	89 e5                	mov    %esp,%ebp
 184:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 185:	8b 7d 08             	mov    0x8(%ebp),%edi
 188:	8b 4d 10             	mov    0x10(%ebp),%ecx
 18b:	8b 45 0c             	mov    0xc(%ebp),%eax
 18e:	fc                   	cld    
 18f:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 191:	8b 45 08             	mov    0x8(%ebp),%eax
 194:	5f                   	pop    %edi
 195:	5d                   	pop    %ebp
 196:	c3                   	ret    

00000197 <strchr>:

char*
strchr(const char *s, char c)
{
 197:	f3 0f 1e fb          	endbr32 
 19b:	55                   	push   %ebp
 19c:	89 e5                	mov    %esp,%ebp
 19e:	8b 45 08             	mov    0x8(%ebp),%eax
 1a1:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 1a4:	8a 10                	mov    (%eax),%dl
 1a6:	84 d2                	test   %dl,%dl
 1a8:	74 07                	je     1b1 <strchr+0x1a>
    if(*s == c)
 1aa:	38 ca                	cmp    %cl,%dl
 1ac:	74 08                	je     1b6 <strchr+0x1f>
  for(; *s; s++)
 1ae:	40                   	inc    %eax
 1af:	eb f3                	jmp    1a4 <strchr+0xd>
      return (char*)s;
  return 0;
 1b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
 1b6:	5d                   	pop    %ebp
 1b7:	c3                   	ret    

000001b8 <gets>:

char*
gets(char *buf, int max)
{
 1b8:	f3 0f 1e fb          	endbr32 
 1bc:	55                   	push   %ebp
 1bd:	89 e5                	mov    %esp,%ebp
 1bf:	57                   	push   %edi
 1c0:	56                   	push   %esi
 1c1:	53                   	push   %ebx
 1c2:	83 ec 1c             	sub    $0x1c,%esp
 1c5:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 1c8:	bb 00 00 00 00       	mov    $0x0,%ebx
 1cd:	89 de                	mov    %ebx,%esi
 1cf:	43                   	inc    %ebx
 1d0:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 1d3:	7d 2b                	jge    200 <gets+0x48>
    cc = read(0, &c, 1);
 1d5:	83 ec 04             	sub    $0x4,%esp
 1d8:	6a 01                	push   $0x1
 1da:	8d 45 e7             	lea    -0x19(%ebp),%eax
 1dd:	50                   	push   %eax
 1de:	6a 00                	push   $0x0
 1e0:	e8 ed 00 00 00       	call   2d2 <read>
    if(cc < 1)
 1e5:	83 c4 10             	add    $0x10,%esp
 1e8:	85 c0                	test   %eax,%eax
 1ea:	7e 14                	jle    200 <gets+0x48>
      break;
    buf[i++] = c;
 1ec:	8a 45 e7             	mov    -0x19(%ebp),%al
 1ef:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 1f2:	3c 0a                	cmp    $0xa,%al
 1f4:	74 08                	je     1fe <gets+0x46>
 1f6:	3c 0d                	cmp    $0xd,%al
 1f8:	75 d3                	jne    1cd <gets+0x15>
    buf[i++] = c;
 1fa:	89 de                	mov    %ebx,%esi
 1fc:	eb 02                	jmp    200 <gets+0x48>
 1fe:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 200:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 204:	89 f8                	mov    %edi,%eax
 206:	8d 65 f4             	lea    -0xc(%ebp),%esp
 209:	5b                   	pop    %ebx
 20a:	5e                   	pop    %esi
 20b:	5f                   	pop    %edi
 20c:	5d                   	pop    %ebp
 20d:	c3                   	ret    

0000020e <stat>:

int
stat(const char *n, struct stat *st)
{
 20e:	f3 0f 1e fb          	endbr32 
 212:	55                   	push   %ebp
 213:	89 e5                	mov    %esp,%ebp
 215:	56                   	push   %esi
 216:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 217:	83 ec 08             	sub    $0x8,%esp
 21a:	6a 00                	push   $0x0
 21c:	ff 75 08             	pushl  0x8(%ebp)
 21f:	e8 d6 00 00 00       	call   2fa <open>
  if(fd < 0)
 224:	83 c4 10             	add    $0x10,%esp
 227:	85 c0                	test   %eax,%eax
 229:	78 24                	js     24f <stat+0x41>
 22b:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 22d:	83 ec 08             	sub    $0x8,%esp
 230:	ff 75 0c             	pushl  0xc(%ebp)
 233:	50                   	push   %eax
 234:	e8 d9 00 00 00       	call   312 <fstat>
 239:	89 c6                	mov    %eax,%esi
  close(fd);
 23b:	89 1c 24             	mov    %ebx,(%esp)
 23e:	e8 9f 00 00 00       	call   2e2 <close>
  return r;
 243:	83 c4 10             	add    $0x10,%esp
}
 246:	89 f0                	mov    %esi,%eax
 248:	8d 65 f8             	lea    -0x8(%ebp),%esp
 24b:	5b                   	pop    %ebx
 24c:	5e                   	pop    %esi
 24d:	5d                   	pop    %ebp
 24e:	c3                   	ret    
    return -1;
 24f:	be ff ff ff ff       	mov    $0xffffffff,%esi
 254:	eb f0                	jmp    246 <stat+0x38>

00000256 <atoi>:

int
atoi(const char *s)
{
 256:	f3 0f 1e fb          	endbr32 
 25a:	55                   	push   %ebp
 25b:	89 e5                	mov    %esp,%ebp
 25d:	53                   	push   %ebx
 25e:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 261:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 266:	8a 01                	mov    (%ecx),%al
 268:	8d 58 d0             	lea    -0x30(%eax),%ebx
 26b:	80 fb 09             	cmp    $0x9,%bl
 26e:	77 10                	ja     280 <atoi+0x2a>
    n = n*10 + *s++ - '0';
 270:	8d 14 92             	lea    (%edx,%edx,4),%edx
 273:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 276:	41                   	inc    %ecx
 277:	0f be c0             	movsbl %al,%eax
 27a:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
 27e:	eb e6                	jmp    266 <atoi+0x10>
  return n;
}
 280:	89 d0                	mov    %edx,%eax
 282:	5b                   	pop    %ebx
 283:	5d                   	pop    %ebp
 284:	c3                   	ret    

00000285 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 285:	f3 0f 1e fb          	endbr32 
 289:	55                   	push   %ebp
 28a:	89 e5                	mov    %esp,%ebp
 28c:	56                   	push   %esi
 28d:	53                   	push   %ebx
 28e:	8b 45 08             	mov    0x8(%ebp),%eax
 291:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 294:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 297:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 299:	8d 72 ff             	lea    -0x1(%edx),%esi
 29c:	85 d2                	test   %edx,%edx
 29e:	7e 0e                	jle    2ae <memmove+0x29>
    *dst++ = *src++;
 2a0:	8a 13                	mov    (%ebx),%dl
 2a2:	88 11                	mov    %dl,(%ecx)
 2a4:	8d 5b 01             	lea    0x1(%ebx),%ebx
 2a7:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 2aa:	89 f2                	mov    %esi,%edx
 2ac:	eb eb                	jmp    299 <memmove+0x14>
  return vdst;
}
 2ae:	5b                   	pop    %ebx
 2af:	5e                   	pop    %esi
 2b0:	5d                   	pop    %ebp
 2b1:	c3                   	ret    

000002b2 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 2b2:	b8 01 00 00 00       	mov    $0x1,%eax
 2b7:	cd 40                	int    $0x40
 2b9:	c3                   	ret    

000002ba <exit>:
SYSCALL(exit)
 2ba:	b8 02 00 00 00       	mov    $0x2,%eax
 2bf:	cd 40                	int    $0x40
 2c1:	c3                   	ret    

000002c2 <wait>:
SYSCALL(wait)
 2c2:	b8 03 00 00 00       	mov    $0x3,%eax
 2c7:	cd 40                	int    $0x40
 2c9:	c3                   	ret    

000002ca <pipe>:
SYSCALL(pipe)
 2ca:	b8 04 00 00 00       	mov    $0x4,%eax
 2cf:	cd 40                	int    $0x40
 2d1:	c3                   	ret    

000002d2 <read>:
SYSCALL(read)
 2d2:	b8 05 00 00 00       	mov    $0x5,%eax
 2d7:	cd 40                	int    $0x40
 2d9:	c3                   	ret    

000002da <write>:
SYSCALL(write)
 2da:	b8 10 00 00 00       	mov    $0x10,%eax
 2df:	cd 40                	int    $0x40
 2e1:	c3                   	ret    

000002e2 <close>:
SYSCALL(close)
 2e2:	b8 15 00 00 00       	mov    $0x15,%eax
 2e7:	cd 40                	int    $0x40
 2e9:	c3                   	ret    

000002ea <kill>:
SYSCALL(kill)
 2ea:	b8 06 00 00 00       	mov    $0x6,%eax
 2ef:	cd 40                	int    $0x40
 2f1:	c3                   	ret    

000002f2 <exec>:
SYSCALL(exec)
 2f2:	b8 07 00 00 00       	mov    $0x7,%eax
 2f7:	cd 40                	int    $0x40
 2f9:	c3                   	ret    

000002fa <open>:
SYSCALL(open)
 2fa:	b8 0f 00 00 00       	mov    $0xf,%eax
 2ff:	cd 40                	int    $0x40
 301:	c3                   	ret    

00000302 <mknod>:
SYSCALL(mknod)
 302:	b8 11 00 00 00       	mov    $0x11,%eax
 307:	cd 40                	int    $0x40
 309:	c3                   	ret    

0000030a <unlink>:
SYSCALL(unlink)
 30a:	b8 12 00 00 00       	mov    $0x12,%eax
 30f:	cd 40                	int    $0x40
 311:	c3                   	ret    

00000312 <fstat>:
SYSCALL(fstat)
 312:	b8 08 00 00 00       	mov    $0x8,%eax
 317:	cd 40                	int    $0x40
 319:	c3                   	ret    

0000031a <link>:
SYSCALL(link)
 31a:	b8 13 00 00 00       	mov    $0x13,%eax
 31f:	cd 40                	int    $0x40
 321:	c3                   	ret    

00000322 <mkdir>:
SYSCALL(mkdir)
 322:	b8 14 00 00 00       	mov    $0x14,%eax
 327:	cd 40                	int    $0x40
 329:	c3                   	ret    

0000032a <chdir>:
SYSCALL(chdir)
 32a:	b8 09 00 00 00       	mov    $0x9,%eax
 32f:	cd 40                	int    $0x40
 331:	c3                   	ret    

00000332 <dup>:
SYSCALL(dup)
 332:	b8 0a 00 00 00       	mov    $0xa,%eax
 337:	cd 40                	int    $0x40
 339:	c3                   	ret    

0000033a <getpid>:
SYSCALL(getpid)
 33a:	b8 0b 00 00 00       	mov    $0xb,%eax
 33f:	cd 40                	int    $0x40
 341:	c3                   	ret    

00000342 <sbrk>:
SYSCALL(sbrk)
 342:	b8 0c 00 00 00       	mov    $0xc,%eax
 347:	cd 40                	int    $0x40
 349:	c3                   	ret    

0000034a <sleep>:
SYSCALL(sleep)
 34a:	b8 0d 00 00 00       	mov    $0xd,%eax
 34f:	cd 40                	int    $0x40
 351:	c3                   	ret    

00000352 <uptime>:
SYSCALL(uptime)
 352:	b8 0e 00 00 00       	mov    $0xe,%eax
 357:	cd 40                	int    $0x40
 359:	c3                   	ret    

0000035a <date>:
SYSCALL(date)
 35a:	b8 16 00 00 00       	mov    $0x16,%eax
 35f:	cd 40                	int    $0x40
 361:	c3                   	ret    

00000362 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 362:	55                   	push   %ebp
 363:	89 e5                	mov    %esp,%ebp
 365:	83 ec 1c             	sub    $0x1c,%esp
 368:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 36b:	6a 01                	push   $0x1
 36d:	8d 55 f4             	lea    -0xc(%ebp),%edx
 370:	52                   	push   %edx
 371:	50                   	push   %eax
 372:	e8 63 ff ff ff       	call   2da <write>
}
 377:	83 c4 10             	add    $0x10,%esp
 37a:	c9                   	leave  
 37b:	c3                   	ret    

0000037c <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 37c:	55                   	push   %ebp
 37d:	89 e5                	mov    %esp,%ebp
 37f:	57                   	push   %edi
 380:	56                   	push   %esi
 381:	53                   	push   %ebx
 382:	83 ec 2c             	sub    $0x2c,%esp
 385:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 388:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 38a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 38e:	74 04                	je     394 <printint+0x18>
 390:	85 d2                	test   %edx,%edx
 392:	78 3a                	js     3ce <printint+0x52>
  neg = 0;
 394:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 39b:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 3a0:	89 f0                	mov    %esi,%eax
 3a2:	ba 00 00 00 00       	mov    $0x0,%edx
 3a7:	f7 f1                	div    %ecx
 3a9:	89 df                	mov    %ebx,%edi
 3ab:	43                   	inc    %ebx
 3ac:	8a 92 80 05 00 00    	mov    0x580(%edx),%dl
 3b2:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3b6:	89 f2                	mov    %esi,%edx
 3b8:	89 c6                	mov    %eax,%esi
 3ba:	39 d1                	cmp    %edx,%ecx
 3bc:	76 e2                	jbe    3a0 <printint+0x24>
  if(neg)
 3be:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 3c2:	74 22                	je     3e6 <printint+0x6a>
    buf[i++] = '-';
 3c4:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3c9:	8d 5f 02             	lea    0x2(%edi),%ebx
 3cc:	eb 18                	jmp    3e6 <printint+0x6a>
    x = -xx;
 3ce:	f7 de                	neg    %esi
    neg = 1;
 3d0:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 3d7:	eb c2                	jmp    39b <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 3d9:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 3de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 3e1:	e8 7c ff ff ff       	call   362 <putc>
  while(--i >= 0)
 3e6:	4b                   	dec    %ebx
 3e7:	79 f0                	jns    3d9 <printint+0x5d>
}
 3e9:	83 c4 2c             	add    $0x2c,%esp
 3ec:	5b                   	pop    %ebx
 3ed:	5e                   	pop    %esi
 3ee:	5f                   	pop    %edi
 3ef:	5d                   	pop    %ebp
 3f0:	c3                   	ret    

000003f1 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3f1:	f3 0f 1e fb          	endbr32 
 3f5:	55                   	push   %ebp
 3f6:	89 e5                	mov    %esp,%ebp
 3f8:	57                   	push   %edi
 3f9:	56                   	push   %esi
 3fa:	53                   	push   %ebx
 3fb:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3fe:	8d 45 10             	lea    0x10(%ebp),%eax
 401:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 404:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 409:	bb 00 00 00 00       	mov    $0x0,%ebx
 40e:	eb 12                	jmp    422 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 410:	89 fa                	mov    %edi,%edx
 412:	8b 45 08             	mov    0x8(%ebp),%eax
 415:	e8 48 ff ff ff       	call   362 <putc>
 41a:	eb 05                	jmp    421 <printf+0x30>
      }
    } else if(state == '%'){
 41c:	83 fe 25             	cmp    $0x25,%esi
 41f:	74 22                	je     443 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 421:	43                   	inc    %ebx
 422:	8b 45 0c             	mov    0xc(%ebp),%eax
 425:	8a 04 18             	mov    (%eax,%ebx,1),%al
 428:	84 c0                	test   %al,%al
 42a:	0f 84 13 01 00 00    	je     543 <printf+0x152>
    c = fmt[i] & 0xff;
 430:	0f be f8             	movsbl %al,%edi
 433:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 436:	85 f6                	test   %esi,%esi
 438:	75 e2                	jne    41c <printf+0x2b>
      if(c == '%'){
 43a:	83 f8 25             	cmp    $0x25,%eax
 43d:	75 d1                	jne    410 <printf+0x1f>
        state = '%';
 43f:	89 c6                	mov    %eax,%esi
 441:	eb de                	jmp    421 <printf+0x30>
      if(c == 'd'){
 443:	83 f8 64             	cmp    $0x64,%eax
 446:	74 43                	je     48b <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 448:	83 f8 78             	cmp    $0x78,%eax
 44b:	74 68                	je     4b5 <printf+0xc4>
 44d:	83 f8 70             	cmp    $0x70,%eax
 450:	74 63                	je     4b5 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 452:	83 f8 73             	cmp    $0x73,%eax
 455:	0f 84 84 00 00 00    	je     4df <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 45b:	83 f8 63             	cmp    $0x63,%eax
 45e:	0f 84 ad 00 00 00    	je     511 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 464:	83 f8 25             	cmp    $0x25,%eax
 467:	0f 84 c2 00 00 00    	je     52f <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 46d:	ba 25 00 00 00       	mov    $0x25,%edx
 472:	8b 45 08             	mov    0x8(%ebp),%eax
 475:	e8 e8 fe ff ff       	call   362 <putc>
        putc(fd, c);
 47a:	89 fa                	mov    %edi,%edx
 47c:	8b 45 08             	mov    0x8(%ebp),%eax
 47f:	e8 de fe ff ff       	call   362 <putc>
      }
      state = 0;
 484:	be 00 00 00 00       	mov    $0x0,%esi
 489:	eb 96                	jmp    421 <printf+0x30>
        printint(fd, *ap, 10, 1);
 48b:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 48e:	8b 17                	mov    (%edi),%edx
 490:	83 ec 0c             	sub    $0xc,%esp
 493:	6a 01                	push   $0x1
 495:	b9 0a 00 00 00       	mov    $0xa,%ecx
 49a:	8b 45 08             	mov    0x8(%ebp),%eax
 49d:	e8 da fe ff ff       	call   37c <printint>
        ap++;
 4a2:	83 c7 04             	add    $0x4,%edi
 4a5:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4a8:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4ab:	be 00 00 00 00       	mov    $0x0,%esi
 4b0:	e9 6c ff ff ff       	jmp    421 <printf+0x30>
        printint(fd, *ap, 16, 0);
 4b5:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4b8:	8b 17                	mov    (%edi),%edx
 4ba:	83 ec 0c             	sub    $0xc,%esp
 4bd:	6a 00                	push   $0x0
 4bf:	b9 10 00 00 00       	mov    $0x10,%ecx
 4c4:	8b 45 08             	mov    0x8(%ebp),%eax
 4c7:	e8 b0 fe ff ff       	call   37c <printint>
        ap++;
 4cc:	83 c7 04             	add    $0x4,%edi
 4cf:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4d2:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4d5:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 4da:	e9 42 ff ff ff       	jmp    421 <printf+0x30>
        s = (char*)*ap;
 4df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4e2:	8b 30                	mov    (%eax),%esi
        ap++;
 4e4:	83 c0 04             	add    $0x4,%eax
 4e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 4ea:	85 f6                	test   %esi,%esi
 4ec:	75 13                	jne    501 <printf+0x110>
          s = "(null)";
 4ee:	be 79 05 00 00       	mov    $0x579,%esi
 4f3:	eb 0c                	jmp    501 <printf+0x110>
          putc(fd, *s);
 4f5:	0f be d2             	movsbl %dl,%edx
 4f8:	8b 45 08             	mov    0x8(%ebp),%eax
 4fb:	e8 62 fe ff ff       	call   362 <putc>
          s++;
 500:	46                   	inc    %esi
        while(*s != 0){
 501:	8a 16                	mov    (%esi),%dl
 503:	84 d2                	test   %dl,%dl
 505:	75 ee                	jne    4f5 <printf+0x104>
      state = 0;
 507:	be 00 00 00 00       	mov    $0x0,%esi
 50c:	e9 10 ff ff ff       	jmp    421 <printf+0x30>
        putc(fd, *ap);
 511:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 514:	0f be 17             	movsbl (%edi),%edx
 517:	8b 45 08             	mov    0x8(%ebp),%eax
 51a:	e8 43 fe ff ff       	call   362 <putc>
        ap++;
 51f:	83 c7 04             	add    $0x4,%edi
 522:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 525:	be 00 00 00 00       	mov    $0x0,%esi
 52a:	e9 f2 fe ff ff       	jmp    421 <printf+0x30>
        putc(fd, c);
 52f:	89 fa                	mov    %edi,%edx
 531:	8b 45 08             	mov    0x8(%ebp),%eax
 534:	e8 29 fe ff ff       	call   362 <putc>
      state = 0;
 539:	be 00 00 00 00       	mov    $0x0,%esi
 53e:	e9 de fe ff ff       	jmp    421 <printf+0x30>
    }
  }
}
 543:	8d 65 f4             	lea    -0xc(%ebp),%esp
 546:	5b                   	pop    %ebx
 547:	5e                   	pop    %esi
 548:	5f                   	pop    %edi
 549:	5d                   	pop    %ebp
 54a:	c3                   	ret    
