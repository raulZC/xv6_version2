
tprio3:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <do_calc>:
#include "types.h"
#include "user.h"

void
do_calc (char* nombre)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	53                   	push   %ebx
   8:	83 ec 04             	sub    $0x4,%esp
  int r = 0;

  for (int i = 0; i < 2000; ++i)
   b:	bb 00 00 00 00       	mov    $0x0,%ebx
  int r = 0;
  10:	ba 00 00 00 00       	mov    $0x0,%edx
  for (int i = 0; i < 2000; ++i)
  15:	eb 01                	jmp    18 <do_calc+0x18>
  17:	43                   	inc    %ebx
  18:	81 fb cf 07 00 00    	cmp    $0x7cf,%ebx
  1e:	7f 14                	jg     34 <do_calc+0x34>
    for (int j = 0; j < 1000000; ++j)
  20:	b8 00 00 00 00       	mov    $0x0,%eax
  25:	3d 3f 42 0f 00       	cmp    $0xf423f,%eax
  2a:	7f eb                	jg     17 <do_calc+0x17>
      r += i + j;
  2c:	8d 0c 03             	lea    (%ebx,%eax,1),%ecx
  2f:	01 ca                	add    %ecx,%edx
    for (int j = 0; j < 1000000; ++j)
  31:	40                   	inc    %eax
  32:	eb f1                	jmp    25 <do_calc+0x25>

  // Imprime el resultado
  printf (1, "%s: %d\n", nombre, r);
  34:	52                   	push   %edx
  35:	ff 75 08             	pushl  0x8(%ebp)
  38:	68 68 03 00 00       	push   $0x368
  3d:	6a 01                	push   $0x1
  3f:	e8 c8 01 00 00       	call   20c <printf>
}
  44:	83 c4 10             	add    $0x10,%esp
  47:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  4a:	c9                   	leave  
  4b:	c3                   	ret    

0000004c <main>:


int
main(int argc, char *argv[])
{
  4c:	f3 0f 1e fb          	endbr32 
  50:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  54:	83 e4 f0             	and    $0xfffffff0,%esp
  57:	ff 71 fc             	pushl  -0x4(%ecx)
  5a:	55                   	push   %ebp
  5b:	89 e5                	mov    %esp,%ebp
  5d:	51                   	push   %ecx
  5e:	83 ec 04             	sub    $0x4,%esp
  // El proceso se inicia en baja prioridad.
  // Genera otro proceso hijo que a su vez genera dos
  if (fork() == 0)
  61:	e8 4f 00 00 00       	call   b5 <fork>
  66:	85 c0                	test   %eax,%eax
  68:	75 1e                	jne    88 <main+0x3c>
  {
    fork();  // Ambos ejecutan:
  6a:	e8 46 00 00 00       	call   b5 <fork>
    do_calc("Low");
  6f:	83 ec 0c             	sub    $0xc,%esp
  72:	68 70 03 00 00       	push   $0x370
  77:	e8 84 ff ff ff       	call   0 <do_calc>
    exit(0);
  7c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  83:	e8 35 00 00 00       	call   bd <exit>
  }

  // Establecer máxima prioridad. Debe hacer que el shell ni aparezca hasta
  // que termine
  setprio (getpid(), HI_PRIO);
  88:	e8 b0 00 00 00       	call   13d <getpid>
  8d:	83 ec 08             	sub    $0x8,%esp
  90:	6a 01                	push   $0x1
  92:	50                   	push   %eax
  93:	e8 dd 00 00 00       	call   175 <setprio>

  fork();  // Ambos ejecutan:
  98:	e8 18 00 00 00       	call   b5 <fork>
  do_calc("Hi");
  9d:	c7 04 24 74 03 00 00 	movl   $0x374,(%esp)
  a4:	e8 57 ff ff ff       	call   0 <do_calc>
  exit(0);
  a9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  b0:	e8 08 00 00 00       	call   bd <exit>

000000b5 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  b5:	b8 01 00 00 00       	mov    $0x1,%eax
  ba:	cd 40                	int    $0x40
  bc:	c3                   	ret    

000000bd <exit>:
SYSCALL(exit)
  bd:	b8 02 00 00 00       	mov    $0x2,%eax
  c2:	cd 40                	int    $0x40
  c4:	c3                   	ret    

000000c5 <wait>:
SYSCALL(wait)
  c5:	b8 03 00 00 00       	mov    $0x3,%eax
  ca:	cd 40                	int    $0x40
  cc:	c3                   	ret    

000000cd <pipe>:
SYSCALL(pipe)
  cd:	b8 04 00 00 00       	mov    $0x4,%eax
  d2:	cd 40                	int    $0x40
  d4:	c3                   	ret    

000000d5 <read>:
SYSCALL(read)
  d5:	b8 05 00 00 00       	mov    $0x5,%eax
  da:	cd 40                	int    $0x40
  dc:	c3                   	ret    

000000dd <write>:
SYSCALL(write)
  dd:	b8 10 00 00 00       	mov    $0x10,%eax
  e2:	cd 40                	int    $0x40
  e4:	c3                   	ret    

000000e5 <close>:
SYSCALL(close)
  e5:	b8 15 00 00 00       	mov    $0x15,%eax
  ea:	cd 40                	int    $0x40
  ec:	c3                   	ret    

000000ed <kill>:
SYSCALL(kill)
  ed:	b8 06 00 00 00       	mov    $0x6,%eax
  f2:	cd 40                	int    $0x40
  f4:	c3                   	ret    

000000f5 <exec>:
SYSCALL(exec)
  f5:	b8 07 00 00 00       	mov    $0x7,%eax
  fa:	cd 40                	int    $0x40
  fc:	c3                   	ret    

000000fd <open>:
SYSCALL(open)
  fd:	b8 0f 00 00 00       	mov    $0xf,%eax
 102:	cd 40                	int    $0x40
 104:	c3                   	ret    

00000105 <mknod>:
SYSCALL(mknod)
 105:	b8 11 00 00 00       	mov    $0x11,%eax
 10a:	cd 40                	int    $0x40
 10c:	c3                   	ret    

0000010d <unlink>:
SYSCALL(unlink)
 10d:	b8 12 00 00 00       	mov    $0x12,%eax
 112:	cd 40                	int    $0x40
 114:	c3                   	ret    

00000115 <fstat>:
SYSCALL(fstat)
 115:	b8 08 00 00 00       	mov    $0x8,%eax
 11a:	cd 40                	int    $0x40
 11c:	c3                   	ret    

0000011d <link>:
SYSCALL(link)
 11d:	b8 13 00 00 00       	mov    $0x13,%eax
 122:	cd 40                	int    $0x40
 124:	c3                   	ret    

00000125 <mkdir>:
SYSCALL(mkdir)
 125:	b8 14 00 00 00       	mov    $0x14,%eax
 12a:	cd 40                	int    $0x40
 12c:	c3                   	ret    

0000012d <chdir>:
SYSCALL(chdir)
 12d:	b8 09 00 00 00       	mov    $0x9,%eax
 132:	cd 40                	int    $0x40
 134:	c3                   	ret    

00000135 <dup>:
SYSCALL(dup)
 135:	b8 0a 00 00 00       	mov    $0xa,%eax
 13a:	cd 40                	int    $0x40
 13c:	c3                   	ret    

0000013d <getpid>:
SYSCALL(getpid)
 13d:	b8 0b 00 00 00       	mov    $0xb,%eax
 142:	cd 40                	int    $0x40
 144:	c3                   	ret    

00000145 <sbrk>:
SYSCALL(sbrk)
 145:	b8 0c 00 00 00       	mov    $0xc,%eax
 14a:	cd 40                	int    $0x40
 14c:	c3                   	ret    

0000014d <sleep>:
SYSCALL(sleep)
 14d:	b8 0d 00 00 00       	mov    $0xd,%eax
 152:	cd 40                	int    $0x40
 154:	c3                   	ret    

00000155 <uptime>:
SYSCALL(uptime)
 155:	b8 0e 00 00 00       	mov    $0xe,%eax
 15a:	cd 40                	int    $0x40
 15c:	c3                   	ret    

0000015d <date>:
SYSCALL(date)
 15d:	b8 16 00 00 00       	mov    $0x16,%eax
 162:	cd 40                	int    $0x40
 164:	c3                   	ret    

00000165 <dup2>:
SYSCALL(dup2)
 165:	b8 17 00 00 00       	mov    $0x17,%eax
 16a:	cd 40                	int    $0x40
 16c:	c3                   	ret    

0000016d <getprio>:
SYSCALL(getprio)
 16d:	b8 18 00 00 00       	mov    $0x18,%eax
 172:	cd 40                	int    $0x40
 174:	c3                   	ret    

00000175 <setprio>:
 175:	b8 19 00 00 00       	mov    $0x19,%eax
 17a:	cd 40                	int    $0x40
 17c:	c3                   	ret    

0000017d <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 17d:	55                   	push   %ebp
 17e:	89 e5                	mov    %esp,%ebp
 180:	83 ec 1c             	sub    $0x1c,%esp
 183:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 186:	6a 01                	push   $0x1
 188:	8d 55 f4             	lea    -0xc(%ebp),%edx
 18b:	52                   	push   %edx
 18c:	50                   	push   %eax
 18d:	e8 4b ff ff ff       	call   dd <write>
}
 192:	83 c4 10             	add    $0x10,%esp
 195:	c9                   	leave  
 196:	c3                   	ret    

00000197 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 197:	55                   	push   %ebp
 198:	89 e5                	mov    %esp,%ebp
 19a:	57                   	push   %edi
 19b:	56                   	push   %esi
 19c:	53                   	push   %ebx
 19d:	83 ec 2c             	sub    $0x2c,%esp
 1a0:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 1a3:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 1a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 1a9:	74 04                	je     1af <printint+0x18>
 1ab:	85 d2                	test   %edx,%edx
 1ad:	78 3a                	js     1e9 <printint+0x52>
  neg = 0;
 1af:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 1b6:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 1bb:	89 f0                	mov    %esi,%eax
 1bd:	ba 00 00 00 00       	mov    $0x0,%edx
 1c2:	f7 f1                	div    %ecx
 1c4:	89 df                	mov    %ebx,%edi
 1c6:	43                   	inc    %ebx
 1c7:	8a 92 80 03 00 00    	mov    0x380(%edx),%dl
 1cd:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 1d1:	89 f2                	mov    %esi,%edx
 1d3:	89 c6                	mov    %eax,%esi
 1d5:	39 d1                	cmp    %edx,%ecx
 1d7:	76 e2                	jbe    1bb <printint+0x24>
  if(neg)
 1d9:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 1dd:	74 22                	je     201 <printint+0x6a>
    buf[i++] = '-';
 1df:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 1e4:	8d 5f 02             	lea    0x2(%edi),%ebx
 1e7:	eb 18                	jmp    201 <printint+0x6a>
    x = -xx;
 1e9:	f7 de                	neg    %esi
    neg = 1;
 1eb:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 1f2:	eb c2                	jmp    1b6 <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 1f4:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 1f9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1fc:	e8 7c ff ff ff       	call   17d <putc>
  while(--i >= 0)
 201:	4b                   	dec    %ebx
 202:	79 f0                	jns    1f4 <printint+0x5d>
}
 204:	83 c4 2c             	add    $0x2c,%esp
 207:	5b                   	pop    %ebx
 208:	5e                   	pop    %esi
 209:	5f                   	pop    %edi
 20a:	5d                   	pop    %ebp
 20b:	c3                   	ret    

0000020c <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 20c:	f3 0f 1e fb          	endbr32 
 210:	55                   	push   %ebp
 211:	89 e5                	mov    %esp,%ebp
 213:	57                   	push   %edi
 214:	56                   	push   %esi
 215:	53                   	push   %ebx
 216:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 219:	8d 45 10             	lea    0x10(%ebp),%eax
 21c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 21f:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 224:	bb 00 00 00 00       	mov    $0x0,%ebx
 229:	eb 12                	jmp    23d <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 22b:	89 fa                	mov    %edi,%edx
 22d:	8b 45 08             	mov    0x8(%ebp),%eax
 230:	e8 48 ff ff ff       	call   17d <putc>
 235:	eb 05                	jmp    23c <printf+0x30>
      }
    } else if(state == '%'){
 237:	83 fe 25             	cmp    $0x25,%esi
 23a:	74 22                	je     25e <printf+0x52>
  for(i = 0; fmt[i]; i++){
 23c:	43                   	inc    %ebx
 23d:	8b 45 0c             	mov    0xc(%ebp),%eax
 240:	8a 04 18             	mov    (%eax,%ebx,1),%al
 243:	84 c0                	test   %al,%al
 245:	0f 84 13 01 00 00    	je     35e <printf+0x152>
    c = fmt[i] & 0xff;
 24b:	0f be f8             	movsbl %al,%edi
 24e:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 251:	85 f6                	test   %esi,%esi
 253:	75 e2                	jne    237 <printf+0x2b>
      if(c == '%'){
 255:	83 f8 25             	cmp    $0x25,%eax
 258:	75 d1                	jne    22b <printf+0x1f>
        state = '%';
 25a:	89 c6                	mov    %eax,%esi
 25c:	eb de                	jmp    23c <printf+0x30>
      if(c == 'd'){
 25e:	83 f8 64             	cmp    $0x64,%eax
 261:	74 43                	je     2a6 <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 263:	83 f8 78             	cmp    $0x78,%eax
 266:	74 68                	je     2d0 <printf+0xc4>
 268:	83 f8 70             	cmp    $0x70,%eax
 26b:	74 63                	je     2d0 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 26d:	83 f8 73             	cmp    $0x73,%eax
 270:	0f 84 84 00 00 00    	je     2fa <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 276:	83 f8 63             	cmp    $0x63,%eax
 279:	0f 84 ad 00 00 00    	je     32c <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 27f:	83 f8 25             	cmp    $0x25,%eax
 282:	0f 84 c2 00 00 00    	je     34a <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 288:	ba 25 00 00 00       	mov    $0x25,%edx
 28d:	8b 45 08             	mov    0x8(%ebp),%eax
 290:	e8 e8 fe ff ff       	call   17d <putc>
        putc(fd, c);
 295:	89 fa                	mov    %edi,%edx
 297:	8b 45 08             	mov    0x8(%ebp),%eax
 29a:	e8 de fe ff ff       	call   17d <putc>
      }
      state = 0;
 29f:	be 00 00 00 00       	mov    $0x0,%esi
 2a4:	eb 96                	jmp    23c <printf+0x30>
        printint(fd, *ap, 10, 1);
 2a6:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2a9:	8b 17                	mov    (%edi),%edx
 2ab:	83 ec 0c             	sub    $0xc,%esp
 2ae:	6a 01                	push   $0x1
 2b0:	b9 0a 00 00 00       	mov    $0xa,%ecx
 2b5:	8b 45 08             	mov    0x8(%ebp),%eax
 2b8:	e8 da fe ff ff       	call   197 <printint>
        ap++;
 2bd:	83 c7 04             	add    $0x4,%edi
 2c0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2c3:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2c6:	be 00 00 00 00       	mov    $0x0,%esi
 2cb:	e9 6c ff ff ff       	jmp    23c <printf+0x30>
        printint(fd, *ap, 16, 0);
 2d0:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2d3:	8b 17                	mov    (%edi),%edx
 2d5:	83 ec 0c             	sub    $0xc,%esp
 2d8:	6a 00                	push   $0x0
 2da:	b9 10 00 00 00       	mov    $0x10,%ecx
 2df:	8b 45 08             	mov    0x8(%ebp),%eax
 2e2:	e8 b0 fe ff ff       	call   197 <printint>
        ap++;
 2e7:	83 c7 04             	add    $0x4,%edi
 2ea:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2ed:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2f0:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 2f5:	e9 42 ff ff ff       	jmp    23c <printf+0x30>
        s = (char*)*ap;
 2fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2fd:	8b 30                	mov    (%eax),%esi
        ap++;
 2ff:	83 c0 04             	add    $0x4,%eax
 302:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 305:	85 f6                	test   %esi,%esi
 307:	75 13                	jne    31c <printf+0x110>
          s = "(null)";
 309:	be 77 03 00 00       	mov    $0x377,%esi
 30e:	eb 0c                	jmp    31c <printf+0x110>
          putc(fd, *s);
 310:	0f be d2             	movsbl %dl,%edx
 313:	8b 45 08             	mov    0x8(%ebp),%eax
 316:	e8 62 fe ff ff       	call   17d <putc>
          s++;
 31b:	46                   	inc    %esi
        while(*s != 0){
 31c:	8a 16                	mov    (%esi),%dl
 31e:	84 d2                	test   %dl,%dl
 320:	75 ee                	jne    310 <printf+0x104>
      state = 0;
 322:	be 00 00 00 00       	mov    $0x0,%esi
 327:	e9 10 ff ff ff       	jmp    23c <printf+0x30>
        putc(fd, *ap);
 32c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 32f:	0f be 17             	movsbl (%edi),%edx
 332:	8b 45 08             	mov    0x8(%ebp),%eax
 335:	e8 43 fe ff ff       	call   17d <putc>
        ap++;
 33a:	83 c7 04             	add    $0x4,%edi
 33d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 340:	be 00 00 00 00       	mov    $0x0,%esi
 345:	e9 f2 fe ff ff       	jmp    23c <printf+0x30>
        putc(fd, c);
 34a:	89 fa                	mov    %edi,%edx
 34c:	8b 45 08             	mov    0x8(%ebp),%eax
 34f:	e8 29 fe ff ff       	call   17d <putc>
      state = 0;
 354:	be 00 00 00 00       	mov    $0x0,%esi
 359:	e9 de fe ff ff       	jmp    23c <printf+0x30>
    }
  }
}
 35e:	8d 65 f4             	lea    -0xc(%ebp),%esp
 361:	5b                   	pop    %ebx
 362:	5e                   	pop    %esi
 363:	5f                   	pop    %edi
 364:	5d                   	pop    %ebp
 365:	c3                   	ret    
