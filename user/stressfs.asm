
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
  1e:	be 67 05 00 00       	mov    $0x567,%esi
  23:	b9 0a 00 00 00       	mov    $0xa,%ecx
  28:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  char data[512];

  printf(1, "stressfs starting\n");
  2a:	68 44 05 00 00       	push   $0x544
  2f:	6a 01                	push   $0x1
  31:	e8 b3 03 00 00       	call   3e9 <printf>
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
  69:	68 57 05 00 00       	push   $0x557
  6e:	6a 01                	push   $0x1
  70:	e8 74 03 00 00       	call   3e9 <printf>

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
  bf:	68 61 05 00 00       	push   $0x561
  c4:	6a 01                	push   $0x1
  c6:	e8 1e 03 00 00       	call   3e9 <printf>

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

0000035a <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 35a:	55                   	push   %ebp
 35b:	89 e5                	mov    %esp,%ebp
 35d:	83 ec 1c             	sub    $0x1c,%esp
 360:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 363:	6a 01                	push   $0x1
 365:	8d 55 f4             	lea    -0xc(%ebp),%edx
 368:	52                   	push   %edx
 369:	50                   	push   %eax
 36a:	e8 6b ff ff ff       	call   2da <write>
}
 36f:	83 c4 10             	add    $0x10,%esp
 372:	c9                   	leave  
 373:	c3                   	ret    

00000374 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 374:	55                   	push   %ebp
 375:	89 e5                	mov    %esp,%ebp
 377:	57                   	push   %edi
 378:	56                   	push   %esi
 379:	53                   	push   %ebx
 37a:	83 ec 2c             	sub    $0x2c,%esp
 37d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 380:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 382:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 386:	74 04                	je     38c <printint+0x18>
 388:	85 d2                	test   %edx,%edx
 38a:	78 3a                	js     3c6 <printint+0x52>
  neg = 0;
 38c:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 393:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 398:	89 f0                	mov    %esi,%eax
 39a:	ba 00 00 00 00       	mov    $0x0,%edx
 39f:	f7 f1                	div    %ecx
 3a1:	89 df                	mov    %ebx,%edi
 3a3:	43                   	inc    %ebx
 3a4:	8a 92 78 05 00 00    	mov    0x578(%edx),%dl
 3aa:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 3ae:	89 f2                	mov    %esi,%edx
 3b0:	89 c6                	mov    %eax,%esi
 3b2:	39 d1                	cmp    %edx,%ecx
 3b4:	76 e2                	jbe    398 <printint+0x24>
  if(neg)
 3b6:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 3ba:	74 22                	je     3de <printint+0x6a>
    buf[i++] = '-';
 3bc:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 3c1:	8d 5f 02             	lea    0x2(%edi),%ebx
 3c4:	eb 18                	jmp    3de <printint+0x6a>
    x = -xx;
 3c6:	f7 de                	neg    %esi
    neg = 1;
 3c8:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 3cf:	eb c2                	jmp    393 <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 3d1:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 3d6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 3d9:	e8 7c ff ff ff       	call   35a <putc>
  while(--i >= 0)
 3de:	4b                   	dec    %ebx
 3df:	79 f0                	jns    3d1 <printint+0x5d>
}
 3e1:	83 c4 2c             	add    $0x2c,%esp
 3e4:	5b                   	pop    %ebx
 3e5:	5e                   	pop    %esi
 3e6:	5f                   	pop    %edi
 3e7:	5d                   	pop    %ebp
 3e8:	c3                   	ret    

000003e9 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 3e9:	f3 0f 1e fb          	endbr32 
 3ed:	55                   	push   %ebp
 3ee:	89 e5                	mov    %esp,%ebp
 3f0:	57                   	push   %edi
 3f1:	56                   	push   %esi
 3f2:	53                   	push   %ebx
 3f3:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 3f6:	8d 45 10             	lea    0x10(%ebp),%eax
 3f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 3fc:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 401:	bb 00 00 00 00       	mov    $0x0,%ebx
 406:	eb 12                	jmp    41a <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 408:	89 fa                	mov    %edi,%edx
 40a:	8b 45 08             	mov    0x8(%ebp),%eax
 40d:	e8 48 ff ff ff       	call   35a <putc>
 412:	eb 05                	jmp    419 <printf+0x30>
      }
    } else if(state == '%'){
 414:	83 fe 25             	cmp    $0x25,%esi
 417:	74 22                	je     43b <printf+0x52>
  for(i = 0; fmt[i]; i++){
 419:	43                   	inc    %ebx
 41a:	8b 45 0c             	mov    0xc(%ebp),%eax
 41d:	8a 04 18             	mov    (%eax,%ebx,1),%al
 420:	84 c0                	test   %al,%al
 422:	0f 84 13 01 00 00    	je     53b <printf+0x152>
    c = fmt[i] & 0xff;
 428:	0f be f8             	movsbl %al,%edi
 42b:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 42e:	85 f6                	test   %esi,%esi
 430:	75 e2                	jne    414 <printf+0x2b>
      if(c == '%'){
 432:	83 f8 25             	cmp    $0x25,%eax
 435:	75 d1                	jne    408 <printf+0x1f>
        state = '%';
 437:	89 c6                	mov    %eax,%esi
 439:	eb de                	jmp    419 <printf+0x30>
      if(c == 'd'){
 43b:	83 f8 64             	cmp    $0x64,%eax
 43e:	74 43                	je     483 <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 440:	83 f8 78             	cmp    $0x78,%eax
 443:	74 68                	je     4ad <printf+0xc4>
 445:	83 f8 70             	cmp    $0x70,%eax
 448:	74 63                	je     4ad <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 44a:	83 f8 73             	cmp    $0x73,%eax
 44d:	0f 84 84 00 00 00    	je     4d7 <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 453:	83 f8 63             	cmp    $0x63,%eax
 456:	0f 84 ad 00 00 00    	je     509 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 45c:	83 f8 25             	cmp    $0x25,%eax
 45f:	0f 84 c2 00 00 00    	je     527 <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 465:	ba 25 00 00 00       	mov    $0x25,%edx
 46a:	8b 45 08             	mov    0x8(%ebp),%eax
 46d:	e8 e8 fe ff ff       	call   35a <putc>
        putc(fd, c);
 472:	89 fa                	mov    %edi,%edx
 474:	8b 45 08             	mov    0x8(%ebp),%eax
 477:	e8 de fe ff ff       	call   35a <putc>
      }
      state = 0;
 47c:	be 00 00 00 00       	mov    $0x0,%esi
 481:	eb 96                	jmp    419 <printf+0x30>
        printint(fd, *ap, 10, 1);
 483:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 486:	8b 17                	mov    (%edi),%edx
 488:	83 ec 0c             	sub    $0xc,%esp
 48b:	6a 01                	push   $0x1
 48d:	b9 0a 00 00 00       	mov    $0xa,%ecx
 492:	8b 45 08             	mov    0x8(%ebp),%eax
 495:	e8 da fe ff ff       	call   374 <printint>
        ap++;
 49a:	83 c7 04             	add    $0x4,%edi
 49d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4a0:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4a3:	be 00 00 00 00       	mov    $0x0,%esi
 4a8:	e9 6c ff ff ff       	jmp    419 <printf+0x30>
        printint(fd, *ap, 16, 0);
 4ad:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 4b0:	8b 17                	mov    (%edi),%edx
 4b2:	83 ec 0c             	sub    $0xc,%esp
 4b5:	6a 00                	push   $0x0
 4b7:	b9 10 00 00 00       	mov    $0x10,%ecx
 4bc:	8b 45 08             	mov    0x8(%ebp),%eax
 4bf:	e8 b0 fe ff ff       	call   374 <printint>
        ap++;
 4c4:	83 c7 04             	add    $0x4,%edi
 4c7:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 4ca:	83 c4 10             	add    $0x10,%esp
      state = 0;
 4cd:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 4d2:	e9 42 ff ff ff       	jmp    419 <printf+0x30>
        s = (char*)*ap;
 4d7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 4da:	8b 30                	mov    (%eax),%esi
        ap++;
 4dc:	83 c0 04             	add    $0x4,%eax
 4df:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 4e2:	85 f6                	test   %esi,%esi
 4e4:	75 13                	jne    4f9 <printf+0x110>
          s = "(null)";
 4e6:	be 71 05 00 00       	mov    $0x571,%esi
 4eb:	eb 0c                	jmp    4f9 <printf+0x110>
          putc(fd, *s);
 4ed:	0f be d2             	movsbl %dl,%edx
 4f0:	8b 45 08             	mov    0x8(%ebp),%eax
 4f3:	e8 62 fe ff ff       	call   35a <putc>
          s++;
 4f8:	46                   	inc    %esi
        while(*s != 0){
 4f9:	8a 16                	mov    (%esi),%dl
 4fb:	84 d2                	test   %dl,%dl
 4fd:	75 ee                	jne    4ed <printf+0x104>
      state = 0;
 4ff:	be 00 00 00 00       	mov    $0x0,%esi
 504:	e9 10 ff ff ff       	jmp    419 <printf+0x30>
        putc(fd, *ap);
 509:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 50c:	0f be 17             	movsbl (%edi),%edx
 50f:	8b 45 08             	mov    0x8(%ebp),%eax
 512:	e8 43 fe ff ff       	call   35a <putc>
        ap++;
 517:	83 c7 04             	add    $0x4,%edi
 51a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 51d:	be 00 00 00 00       	mov    $0x0,%esi
 522:	e9 f2 fe ff ff       	jmp    419 <printf+0x30>
        putc(fd, c);
 527:	89 fa                	mov    %edi,%edx
 529:	8b 45 08             	mov    0x8(%ebp),%eax
 52c:	e8 29 fe ff ff       	call   35a <putc>
      state = 0;
 531:	be 00 00 00 00       	mov    $0x0,%esi
 536:	e9 de fe ff ff       	jmp    419 <printf+0x30>
    }
  }
}
 53b:	8d 65 f4             	lea    -0xc(%ebp),%esp
 53e:	5b                   	pop    %ebx
 53f:	5e                   	pop    %esi
 540:	5f                   	pop    %edi
 541:	5d                   	pop    %ebp
 542:	c3                   	ret    
