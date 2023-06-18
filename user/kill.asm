
kill:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "stat.h"
#include "user.h"

int
main(int argc, char **argv)
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
  15:	83 ec 08             	sub    $0x8,%esp
  18:	8b 31                	mov    (%ecx),%esi
  1a:	8b 79 04             	mov    0x4(%ecx),%edi
  int i;

  if(argc < 2){
  1d:	83 fe 01             	cmp    $0x1,%esi
  20:	7e 07                	jle    29 <main+0x29>
    printf(2, "usage: kill pid...\n");
    exit(0);
  }
  for(i=1; i<argc; i++)
  22:	bb 01 00 00 00       	mov    $0x1,%ebx
  27:	eb 32                	jmp    5b <main+0x5b>
    printf(2, "usage: kill pid...\n");
  29:	83 ec 08             	sub    $0x8,%esp
  2c:	68 a8 04 00 00       	push   $0x4a8
  31:	6a 02                	push   $0x2
  33:	e8 14 03 00 00       	call   34c <printf>
    exit(0);
  38:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  3f:	e8 c9 01 00 00       	call   20d <exit>
    kill(atoi(argv[i]));
  44:	83 ec 0c             	sub    $0xc,%esp
  47:	ff 34 9f             	pushl  (%edi,%ebx,4)
  4a:	e8 5a 01 00 00       	call   1a9 <atoi>
  4f:	89 04 24             	mov    %eax,(%esp)
  52:	e8 e6 01 00 00       	call   23d <kill>
  for(i=1; i<argc; i++)
  57:	43                   	inc    %ebx
  58:	83 c4 10             	add    $0x10,%esp
  5b:	39 f3                	cmp    %esi,%ebx
  5d:	7c e5                	jl     44 <main+0x44>
  exit(0);
  5f:	83 ec 0c             	sub    $0xc,%esp
  62:	6a 00                	push   $0x0
  64:	e8 a4 01 00 00       	call   20d <exit>

00000069 <start>:
#include <x86.h>

// Entry point of the library	
void
start()
{
  69:	f3 0f 1e fb          	endbr32 
}
  6d:	c3                   	ret    

0000006e <strcpy>:

char*
strcpy(char *s, const char *t)
{
  6e:	f3 0f 1e fb          	endbr32 
  72:	55                   	push   %ebp
  73:	89 e5                	mov    %esp,%ebp
  75:	56                   	push   %esi
  76:	53                   	push   %ebx
  77:	8b 45 08             	mov    0x8(%ebp),%eax
  7a:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
  7d:	89 c2                	mov    %eax,%edx
  7f:	89 cb                	mov    %ecx,%ebx
  81:	41                   	inc    %ecx
  82:	89 d6                	mov    %edx,%esi
  84:	42                   	inc    %edx
  85:	8a 1b                	mov    (%ebx),%bl
  87:	88 1e                	mov    %bl,(%esi)
  89:	84 db                	test   %bl,%bl
  8b:	75 f2                	jne    7f <strcpy+0x11>
    ;
  return os;
}
  8d:	5b                   	pop    %ebx
  8e:	5e                   	pop    %esi
  8f:	5d                   	pop    %ebp
  90:	c3                   	ret    

00000091 <strcmp>:

int
strcmp(const char *p, const char *q)
{
  91:	f3 0f 1e fb          	endbr32 
  95:	55                   	push   %ebp
  96:	89 e5                	mov    %esp,%ebp
  98:	8b 4d 08             	mov    0x8(%ebp),%ecx
  9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
  9e:	8a 01                	mov    (%ecx),%al
  a0:	84 c0                	test   %al,%al
  a2:	74 08                	je     ac <strcmp+0x1b>
  a4:	3a 02                	cmp    (%edx),%al
  a6:	75 04                	jne    ac <strcmp+0x1b>
    p++, q++;
  a8:	41                   	inc    %ecx
  a9:	42                   	inc    %edx
  aa:	eb f2                	jmp    9e <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
  ac:	0f b6 c0             	movzbl %al,%eax
  af:	0f b6 12             	movzbl (%edx),%edx
  b2:	29 d0                	sub    %edx,%eax
}
  b4:	5d                   	pop    %ebp
  b5:	c3                   	ret    

000000b6 <strlen>:

uint
strlen(const char *s)
{
  b6:	f3 0f 1e fb          	endbr32 
  ba:	55                   	push   %ebp
  bb:	89 e5                	mov    %esp,%ebp
  bd:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
  c0:	b8 00 00 00 00       	mov    $0x0,%eax
  c5:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
  c9:	74 03                	je     ce <strlen+0x18>
  cb:	40                   	inc    %eax
  cc:	eb f7                	jmp    c5 <strlen+0xf>
    ;
  return n;
}
  ce:	5d                   	pop    %ebp
  cf:	c3                   	ret    

000000d0 <memset>:

void*
memset(void *dst, int c, uint n)
{
  d0:	f3 0f 1e fb          	endbr32 
  d4:	55                   	push   %ebp
  d5:	89 e5                	mov    %esp,%ebp
  d7:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
  d8:	8b 7d 08             	mov    0x8(%ebp),%edi
  db:	8b 4d 10             	mov    0x10(%ebp),%ecx
  de:	8b 45 0c             	mov    0xc(%ebp),%eax
  e1:	fc                   	cld    
  e2:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
  e4:	8b 45 08             	mov    0x8(%ebp),%eax
  e7:	5f                   	pop    %edi
  e8:	5d                   	pop    %ebp
  e9:	c3                   	ret    

000000ea <strchr>:

char*
strchr(const char *s, char c)
{
  ea:	f3 0f 1e fb          	endbr32 
  ee:	55                   	push   %ebp
  ef:	89 e5                	mov    %esp,%ebp
  f1:	8b 45 08             	mov    0x8(%ebp),%eax
  f4:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
  f7:	8a 10                	mov    (%eax),%dl
  f9:	84 d2                	test   %dl,%dl
  fb:	74 07                	je     104 <strchr+0x1a>
    if(*s == c)
  fd:	38 ca                	cmp    %cl,%dl
  ff:	74 08                	je     109 <strchr+0x1f>
  for(; *s; s++)
 101:	40                   	inc    %eax
 102:	eb f3                	jmp    f7 <strchr+0xd>
      return (char*)s;
  return 0;
 104:	b8 00 00 00 00       	mov    $0x0,%eax
}
 109:	5d                   	pop    %ebp
 10a:	c3                   	ret    

0000010b <gets>:

char*
gets(char *buf, int max)
{
 10b:	f3 0f 1e fb          	endbr32 
 10f:	55                   	push   %ebp
 110:	89 e5                	mov    %esp,%ebp
 112:	57                   	push   %edi
 113:	56                   	push   %esi
 114:	53                   	push   %ebx
 115:	83 ec 1c             	sub    $0x1c,%esp
 118:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 11b:	bb 00 00 00 00       	mov    $0x0,%ebx
 120:	89 de                	mov    %ebx,%esi
 122:	43                   	inc    %ebx
 123:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 126:	7d 2b                	jge    153 <gets+0x48>
    cc = read(0, &c, 1);
 128:	83 ec 04             	sub    $0x4,%esp
 12b:	6a 01                	push   $0x1
 12d:	8d 45 e7             	lea    -0x19(%ebp),%eax
 130:	50                   	push   %eax
 131:	6a 00                	push   $0x0
 133:	e8 ed 00 00 00       	call   225 <read>
    if(cc < 1)
 138:	83 c4 10             	add    $0x10,%esp
 13b:	85 c0                	test   %eax,%eax
 13d:	7e 14                	jle    153 <gets+0x48>
      break;
    buf[i++] = c;
 13f:	8a 45 e7             	mov    -0x19(%ebp),%al
 142:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 145:	3c 0a                	cmp    $0xa,%al
 147:	74 08                	je     151 <gets+0x46>
 149:	3c 0d                	cmp    $0xd,%al
 14b:	75 d3                	jne    120 <gets+0x15>
    buf[i++] = c;
 14d:	89 de                	mov    %ebx,%esi
 14f:	eb 02                	jmp    153 <gets+0x48>
 151:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 153:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 157:	89 f8                	mov    %edi,%eax
 159:	8d 65 f4             	lea    -0xc(%ebp),%esp
 15c:	5b                   	pop    %ebx
 15d:	5e                   	pop    %esi
 15e:	5f                   	pop    %edi
 15f:	5d                   	pop    %ebp
 160:	c3                   	ret    

00000161 <stat>:

int
stat(const char *n, struct stat *st)
{
 161:	f3 0f 1e fb          	endbr32 
 165:	55                   	push   %ebp
 166:	89 e5                	mov    %esp,%ebp
 168:	56                   	push   %esi
 169:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 16a:	83 ec 08             	sub    $0x8,%esp
 16d:	6a 00                	push   $0x0
 16f:	ff 75 08             	pushl  0x8(%ebp)
 172:	e8 d6 00 00 00       	call   24d <open>
  if(fd < 0)
 177:	83 c4 10             	add    $0x10,%esp
 17a:	85 c0                	test   %eax,%eax
 17c:	78 24                	js     1a2 <stat+0x41>
 17e:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 180:	83 ec 08             	sub    $0x8,%esp
 183:	ff 75 0c             	pushl  0xc(%ebp)
 186:	50                   	push   %eax
 187:	e8 d9 00 00 00       	call   265 <fstat>
 18c:	89 c6                	mov    %eax,%esi
  close(fd);
 18e:	89 1c 24             	mov    %ebx,(%esp)
 191:	e8 9f 00 00 00       	call   235 <close>
  return r;
 196:	83 c4 10             	add    $0x10,%esp
}
 199:	89 f0                	mov    %esi,%eax
 19b:	8d 65 f8             	lea    -0x8(%ebp),%esp
 19e:	5b                   	pop    %ebx
 19f:	5e                   	pop    %esi
 1a0:	5d                   	pop    %ebp
 1a1:	c3                   	ret    
    return -1;
 1a2:	be ff ff ff ff       	mov    $0xffffffff,%esi
 1a7:	eb f0                	jmp    199 <stat+0x38>

000001a9 <atoi>:

int
atoi(const char *s)
{
 1a9:	f3 0f 1e fb          	endbr32 
 1ad:	55                   	push   %ebp
 1ae:	89 e5                	mov    %esp,%ebp
 1b0:	53                   	push   %ebx
 1b1:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 1b4:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 1b9:	8a 01                	mov    (%ecx),%al
 1bb:	8d 58 d0             	lea    -0x30(%eax),%ebx
 1be:	80 fb 09             	cmp    $0x9,%bl
 1c1:	77 10                	ja     1d3 <atoi+0x2a>
    n = n*10 + *s++ - '0';
 1c3:	8d 14 92             	lea    (%edx,%edx,4),%edx
 1c6:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 1c9:	41                   	inc    %ecx
 1ca:	0f be c0             	movsbl %al,%eax
 1cd:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
 1d1:	eb e6                	jmp    1b9 <atoi+0x10>
  return n;
}
 1d3:	89 d0                	mov    %edx,%eax
 1d5:	5b                   	pop    %ebx
 1d6:	5d                   	pop    %ebp
 1d7:	c3                   	ret    

000001d8 <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 1d8:	f3 0f 1e fb          	endbr32 
 1dc:	55                   	push   %ebp
 1dd:	89 e5                	mov    %esp,%ebp
 1df:	56                   	push   %esi
 1e0:	53                   	push   %ebx
 1e1:	8b 45 08             	mov    0x8(%ebp),%eax
 1e4:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 1e7:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 1ea:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 1ec:	8d 72 ff             	lea    -0x1(%edx),%esi
 1ef:	85 d2                	test   %edx,%edx
 1f1:	7e 0e                	jle    201 <memmove+0x29>
    *dst++ = *src++;
 1f3:	8a 13                	mov    (%ebx),%dl
 1f5:	88 11                	mov    %dl,(%ecx)
 1f7:	8d 5b 01             	lea    0x1(%ebx),%ebx
 1fa:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 1fd:	89 f2                	mov    %esi,%edx
 1ff:	eb eb                	jmp    1ec <memmove+0x14>
  return vdst;
}
 201:	5b                   	pop    %ebx
 202:	5e                   	pop    %esi
 203:	5d                   	pop    %ebp
 204:	c3                   	ret    

00000205 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 205:	b8 01 00 00 00       	mov    $0x1,%eax
 20a:	cd 40                	int    $0x40
 20c:	c3                   	ret    

0000020d <exit>:
SYSCALL(exit)
 20d:	b8 02 00 00 00       	mov    $0x2,%eax
 212:	cd 40                	int    $0x40
 214:	c3                   	ret    

00000215 <wait>:
SYSCALL(wait)
 215:	b8 03 00 00 00       	mov    $0x3,%eax
 21a:	cd 40                	int    $0x40
 21c:	c3                   	ret    

0000021d <pipe>:
SYSCALL(pipe)
 21d:	b8 04 00 00 00       	mov    $0x4,%eax
 222:	cd 40                	int    $0x40
 224:	c3                   	ret    

00000225 <read>:
SYSCALL(read)
 225:	b8 05 00 00 00       	mov    $0x5,%eax
 22a:	cd 40                	int    $0x40
 22c:	c3                   	ret    

0000022d <write>:
SYSCALL(write)
 22d:	b8 10 00 00 00       	mov    $0x10,%eax
 232:	cd 40                	int    $0x40
 234:	c3                   	ret    

00000235 <close>:
SYSCALL(close)
 235:	b8 15 00 00 00       	mov    $0x15,%eax
 23a:	cd 40                	int    $0x40
 23c:	c3                   	ret    

0000023d <kill>:
SYSCALL(kill)
 23d:	b8 06 00 00 00       	mov    $0x6,%eax
 242:	cd 40                	int    $0x40
 244:	c3                   	ret    

00000245 <exec>:
SYSCALL(exec)
 245:	b8 07 00 00 00       	mov    $0x7,%eax
 24a:	cd 40                	int    $0x40
 24c:	c3                   	ret    

0000024d <open>:
SYSCALL(open)
 24d:	b8 0f 00 00 00       	mov    $0xf,%eax
 252:	cd 40                	int    $0x40
 254:	c3                   	ret    

00000255 <mknod>:
SYSCALL(mknod)
 255:	b8 11 00 00 00       	mov    $0x11,%eax
 25a:	cd 40                	int    $0x40
 25c:	c3                   	ret    

0000025d <unlink>:
SYSCALL(unlink)
 25d:	b8 12 00 00 00       	mov    $0x12,%eax
 262:	cd 40                	int    $0x40
 264:	c3                   	ret    

00000265 <fstat>:
SYSCALL(fstat)
 265:	b8 08 00 00 00       	mov    $0x8,%eax
 26a:	cd 40                	int    $0x40
 26c:	c3                   	ret    

0000026d <link>:
SYSCALL(link)
 26d:	b8 13 00 00 00       	mov    $0x13,%eax
 272:	cd 40                	int    $0x40
 274:	c3                   	ret    

00000275 <mkdir>:
SYSCALL(mkdir)
 275:	b8 14 00 00 00       	mov    $0x14,%eax
 27a:	cd 40                	int    $0x40
 27c:	c3                   	ret    

0000027d <chdir>:
SYSCALL(chdir)
 27d:	b8 09 00 00 00       	mov    $0x9,%eax
 282:	cd 40                	int    $0x40
 284:	c3                   	ret    

00000285 <dup>:
SYSCALL(dup)
 285:	b8 0a 00 00 00       	mov    $0xa,%eax
 28a:	cd 40                	int    $0x40
 28c:	c3                   	ret    

0000028d <getpid>:
SYSCALL(getpid)
 28d:	b8 0b 00 00 00       	mov    $0xb,%eax
 292:	cd 40                	int    $0x40
 294:	c3                   	ret    

00000295 <sbrk>:
SYSCALL(sbrk)
 295:	b8 0c 00 00 00       	mov    $0xc,%eax
 29a:	cd 40                	int    $0x40
 29c:	c3                   	ret    

0000029d <sleep>:
SYSCALL(sleep)
 29d:	b8 0d 00 00 00       	mov    $0xd,%eax
 2a2:	cd 40                	int    $0x40
 2a4:	c3                   	ret    

000002a5 <uptime>:
SYSCALL(uptime)
 2a5:	b8 0e 00 00 00       	mov    $0xe,%eax
 2aa:	cd 40                	int    $0x40
 2ac:	c3                   	ret    

000002ad <date>:
SYSCALL(date)
 2ad:	b8 16 00 00 00       	mov    $0x16,%eax
 2b2:	cd 40                	int    $0x40
 2b4:	c3                   	ret    

000002b5 <dup2>:
 2b5:	b8 17 00 00 00       	mov    $0x17,%eax
 2ba:	cd 40                	int    $0x40
 2bc:	c3                   	ret    

000002bd <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 2bd:	55                   	push   %ebp
 2be:	89 e5                	mov    %esp,%ebp
 2c0:	83 ec 1c             	sub    $0x1c,%esp
 2c3:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 2c6:	6a 01                	push   $0x1
 2c8:	8d 55 f4             	lea    -0xc(%ebp),%edx
 2cb:	52                   	push   %edx
 2cc:	50                   	push   %eax
 2cd:	e8 5b ff ff ff       	call   22d <write>
}
 2d2:	83 c4 10             	add    $0x10,%esp
 2d5:	c9                   	leave  
 2d6:	c3                   	ret    

000002d7 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 2d7:	55                   	push   %ebp
 2d8:	89 e5                	mov    %esp,%ebp
 2da:	57                   	push   %edi
 2db:	56                   	push   %esi
 2dc:	53                   	push   %ebx
 2dd:	83 ec 2c             	sub    $0x2c,%esp
 2e0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 2e3:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 2e5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 2e9:	74 04                	je     2ef <printint+0x18>
 2eb:	85 d2                	test   %edx,%edx
 2ed:	78 3a                	js     329 <printint+0x52>
  neg = 0;
 2ef:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 2f6:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 2fb:	89 f0                	mov    %esi,%eax
 2fd:	ba 00 00 00 00       	mov    $0x0,%edx
 302:	f7 f1                	div    %ecx
 304:	89 df                	mov    %ebx,%edi
 306:	43                   	inc    %ebx
 307:	8a 92 c4 04 00 00    	mov    0x4c4(%edx),%dl
 30d:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 311:	89 f2                	mov    %esi,%edx
 313:	89 c6                	mov    %eax,%esi
 315:	39 d1                	cmp    %edx,%ecx
 317:	76 e2                	jbe    2fb <printint+0x24>
  if(neg)
 319:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 31d:	74 22                	je     341 <printint+0x6a>
    buf[i++] = '-';
 31f:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 324:	8d 5f 02             	lea    0x2(%edi),%ebx
 327:	eb 18                	jmp    341 <printint+0x6a>
    x = -xx;
 329:	f7 de                	neg    %esi
    neg = 1;
 32b:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 332:	eb c2                	jmp    2f6 <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 334:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 339:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 33c:	e8 7c ff ff ff       	call   2bd <putc>
  while(--i >= 0)
 341:	4b                   	dec    %ebx
 342:	79 f0                	jns    334 <printint+0x5d>
}
 344:	83 c4 2c             	add    $0x2c,%esp
 347:	5b                   	pop    %ebx
 348:	5e                   	pop    %esi
 349:	5f                   	pop    %edi
 34a:	5d                   	pop    %ebp
 34b:	c3                   	ret    

0000034c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 34c:	f3 0f 1e fb          	endbr32 
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	57                   	push   %edi
 354:	56                   	push   %esi
 355:	53                   	push   %ebx
 356:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 359:	8d 45 10             	lea    0x10(%ebp),%eax
 35c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 35f:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 364:	bb 00 00 00 00       	mov    $0x0,%ebx
 369:	eb 12                	jmp    37d <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 36b:	89 fa                	mov    %edi,%edx
 36d:	8b 45 08             	mov    0x8(%ebp),%eax
 370:	e8 48 ff ff ff       	call   2bd <putc>
 375:	eb 05                	jmp    37c <printf+0x30>
      }
    } else if(state == '%'){
 377:	83 fe 25             	cmp    $0x25,%esi
 37a:	74 22                	je     39e <printf+0x52>
  for(i = 0; fmt[i]; i++){
 37c:	43                   	inc    %ebx
 37d:	8b 45 0c             	mov    0xc(%ebp),%eax
 380:	8a 04 18             	mov    (%eax,%ebx,1),%al
 383:	84 c0                	test   %al,%al
 385:	0f 84 13 01 00 00    	je     49e <printf+0x152>
    c = fmt[i] & 0xff;
 38b:	0f be f8             	movsbl %al,%edi
 38e:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 391:	85 f6                	test   %esi,%esi
 393:	75 e2                	jne    377 <printf+0x2b>
      if(c == '%'){
 395:	83 f8 25             	cmp    $0x25,%eax
 398:	75 d1                	jne    36b <printf+0x1f>
        state = '%';
 39a:	89 c6                	mov    %eax,%esi
 39c:	eb de                	jmp    37c <printf+0x30>
      if(c == 'd'){
 39e:	83 f8 64             	cmp    $0x64,%eax
 3a1:	74 43                	je     3e6 <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 3a3:	83 f8 78             	cmp    $0x78,%eax
 3a6:	74 68                	je     410 <printf+0xc4>
 3a8:	83 f8 70             	cmp    $0x70,%eax
 3ab:	74 63                	je     410 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 3ad:	83 f8 73             	cmp    $0x73,%eax
 3b0:	0f 84 84 00 00 00    	je     43a <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 3b6:	83 f8 63             	cmp    $0x63,%eax
 3b9:	0f 84 ad 00 00 00    	je     46c <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 3bf:	83 f8 25             	cmp    $0x25,%eax
 3c2:	0f 84 c2 00 00 00    	je     48a <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 3c8:	ba 25 00 00 00       	mov    $0x25,%edx
 3cd:	8b 45 08             	mov    0x8(%ebp),%eax
 3d0:	e8 e8 fe ff ff       	call   2bd <putc>
        putc(fd, c);
 3d5:	89 fa                	mov    %edi,%edx
 3d7:	8b 45 08             	mov    0x8(%ebp),%eax
 3da:	e8 de fe ff ff       	call   2bd <putc>
      }
      state = 0;
 3df:	be 00 00 00 00       	mov    $0x0,%esi
 3e4:	eb 96                	jmp    37c <printf+0x30>
        printint(fd, *ap, 10, 1);
 3e6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3e9:	8b 17                	mov    (%edi),%edx
 3eb:	83 ec 0c             	sub    $0xc,%esp
 3ee:	6a 01                	push   $0x1
 3f0:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3f5:	8b 45 08             	mov    0x8(%ebp),%eax
 3f8:	e8 da fe ff ff       	call   2d7 <printint>
        ap++;
 3fd:	83 c7 04             	add    $0x4,%edi
 400:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 403:	83 c4 10             	add    $0x10,%esp
      state = 0;
 406:	be 00 00 00 00       	mov    $0x0,%esi
 40b:	e9 6c ff ff ff       	jmp    37c <printf+0x30>
        printint(fd, *ap, 16, 0);
 410:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 413:	8b 17                	mov    (%edi),%edx
 415:	83 ec 0c             	sub    $0xc,%esp
 418:	6a 00                	push   $0x0
 41a:	b9 10 00 00 00       	mov    $0x10,%ecx
 41f:	8b 45 08             	mov    0x8(%ebp),%eax
 422:	e8 b0 fe ff ff       	call   2d7 <printint>
        ap++;
 427:	83 c7 04             	add    $0x4,%edi
 42a:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 42d:	83 c4 10             	add    $0x10,%esp
      state = 0;
 430:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 435:	e9 42 ff ff ff       	jmp    37c <printf+0x30>
        s = (char*)*ap;
 43a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 43d:	8b 30                	mov    (%eax),%esi
        ap++;
 43f:	83 c0 04             	add    $0x4,%eax
 442:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 445:	85 f6                	test   %esi,%esi
 447:	75 13                	jne    45c <printf+0x110>
          s = "(null)";
 449:	be bc 04 00 00       	mov    $0x4bc,%esi
 44e:	eb 0c                	jmp    45c <printf+0x110>
          putc(fd, *s);
 450:	0f be d2             	movsbl %dl,%edx
 453:	8b 45 08             	mov    0x8(%ebp),%eax
 456:	e8 62 fe ff ff       	call   2bd <putc>
          s++;
 45b:	46                   	inc    %esi
        while(*s != 0){
 45c:	8a 16                	mov    (%esi),%dl
 45e:	84 d2                	test   %dl,%dl
 460:	75 ee                	jne    450 <printf+0x104>
      state = 0;
 462:	be 00 00 00 00       	mov    $0x0,%esi
 467:	e9 10 ff ff ff       	jmp    37c <printf+0x30>
        putc(fd, *ap);
 46c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 46f:	0f be 17             	movsbl (%edi),%edx
 472:	8b 45 08             	mov    0x8(%ebp),%eax
 475:	e8 43 fe ff ff       	call   2bd <putc>
        ap++;
 47a:	83 c7 04             	add    $0x4,%edi
 47d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 480:	be 00 00 00 00       	mov    $0x0,%esi
 485:	e9 f2 fe ff ff       	jmp    37c <printf+0x30>
        putc(fd, c);
 48a:	89 fa                	mov    %edi,%edx
 48c:	8b 45 08             	mov    0x8(%ebp),%eax
 48f:	e8 29 fe ff ff       	call   2bd <putc>
      state = 0;
 494:	be 00 00 00 00       	mov    $0x0,%esi
 499:	e9 de fe ff ff       	jmp    37c <printf+0x30>
    }
  }
}
 49e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 4a1:	5b                   	pop    %ebx
 4a2:	5e                   	pop    %esi
 4a3:	5f                   	pop    %edi
 4a4:	5d                   	pop    %ebp
 4a5:	c3                   	ret    
