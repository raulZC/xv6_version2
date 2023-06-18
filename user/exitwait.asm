
exitwait:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <forktest>:

#define N  1000

void
forktest(void)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	57                   	push   %edi
   8:	56                   	push   %esi
   9:	53                   	push   %ebx
   a:	83 ec 24             	sub    $0x24,%esp
  int n, pid;
  int status;

  printf(1, "exit/wait with status test\n");
   d:	68 54 04 00 00       	push   $0x454
  12:	6a 01                	push   $0x1
  14:	e8 e1 02 00 00       	call   2fa <printf>

  for(n=0; n<N; n++){
  19:	83 c4 10             	add    $0x10,%esp
  1c:	be 00 00 00 00       	mov    $0x0,%esi
  21:	81 fe e7 03 00 00    	cmp    $0x3e7,%esi
  27:	7f 34                	jg     5d <forktest+0x5d>
    pid = fork();
  29:	e8 85 01 00 00       	call   1b3 <fork>
    if(pid < 0)
  2e:	85 c0                	test   %eax,%eax
  30:	78 2b                	js     5d <forktest+0x5d>
      break;
    if(pid == 0)
  32:	74 03                	je     37 <forktest+0x37>
  for(n=0; n<N; n++){
  34:	46                   	inc    %esi
  35:	eb ea                	jmp    21 <forktest+0x21>
      exit(n - 1/(n/40));  // Some process will fail with divide by 0
  37:	b8 67 66 66 66       	mov    $0x66666667,%eax
  3c:	f7 ee                	imul   %esi
  3e:	89 d1                	mov    %edx,%ecx
  40:	c1 f9 04             	sar    $0x4,%ecx
  43:	89 f0                	mov    %esi,%eax
  45:	c1 f8 1f             	sar    $0x1f,%eax
  48:	29 c1                	sub    %eax,%ecx
  4a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  4f:	99                   	cltd   
  50:	f7 f9                	idiv   %ecx
  52:	83 ec 0c             	sub    $0xc,%esp
  55:	01 f0                	add    %esi,%eax
  57:	50                   	push   %eax
  58:	e8 5e 01 00 00       	call   1bb <exit>
  }

  if(n == N)
  5d:	81 fe e8 03 00 00    	cmp    $0x3e8,%esi
  63:	0f 85 95 00 00 00    	jne    fe <forktest+0xfe>
  {
    printf(1, "fork claimed to work %d times!\n", N);
  69:	83 ec 04             	sub    $0x4,%esp
  6c:	68 e8 03 00 00       	push   $0x3e8
  71:	68 d8 04 00 00       	push   $0x4d8
  76:	6a 01                	push   $0x1
  78:	e8 7d 02 00 00       	call   2fa <printf>
    exit(N);
  7d:	c7 04 24 e8 03 00 00 	movl   $0x3e8,(%esp)
  84:	e8 32 01 00 00       	call   1bb <exit>

  for(; n > 0; n--)
  {
    if((pid = wait(&status)) < 0)
    {
      printf(1, "wait stopped early\n");
  89:	83 ec 08             	sub    $0x8,%esp
  8c:	68 70 04 00 00       	push   $0x470
  91:	6a 01                	push   $0x1
  93:	e8 62 02 00 00       	call   2fa <printf>
      exit(-1);
  98:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
  9f:	e8 17 01 00 00       	call   1bb <exit>
    // Imprimir el stado en formato binario
    printf(1, "status waitexit: ");
    for(int i = 15; i >= 0; i--){
      printf(1,"%d",((status >> i) & 1));
      if(i == 8){
        printf(1," ");
  a4:	83 ec 08             	sub    $0x8,%esp
  a7:	68 94 04 00 00       	push   $0x494
  ac:	6a 01                	push   $0x1
  ae:	e8 47 02 00 00       	call   2fa <printf>
  b3:	83 c4 10             	add    $0x10,%esp
    for(int i = 15; i >= 0; i--){
  b6:	4b                   	dec    %ebx
  b7:	85 db                	test   %ebx,%ebx
  b9:	78 24                	js     df <forktest+0xdf>
      printf(1,"%d",((status >> i) & 1));
  bb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  be:	88 d9                	mov    %bl,%cl
  c0:	d3 f8                	sar    %cl,%eax
  c2:	83 ec 04             	sub    $0x4,%esp
  c5:	83 e0 01             	and    $0x1,%eax
  c8:	50                   	push   %eax
  c9:	68 96 04 00 00       	push   $0x496
  ce:	6a 01                	push   $0x1
  d0:	e8 25 02 00 00       	call   2fa <printf>
      if(i == 8){
  d5:	83 c4 10             	add    $0x10,%esp
  d8:	83 fb 08             	cmp    $0x8,%ebx
  db:	75 d9                	jne    b6 <forktest+0xb6>
  dd:	eb c5                	jmp    a4 <forktest+0xa4>
      }
    }
    if (WIFEXITED (status))
  df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  e2:	89 c2                	mov    %eax,%edx
  e4:	83 e2 7f             	and    $0x7f,%edx
  e7:	75 4b                	jne    134 <forktest+0x134>
      printf (1, "Exited child %d, exitcode %d\n", pid, WEXITSTATUS (status));
  e9:	0f b6 c4             	movzbl %ah,%eax
  ec:	50                   	push   %eax
  ed:	57                   	push   %edi
  ee:	68 99 04 00 00       	push   $0x499
  f3:	6a 01                	push   $0x1
  f5:	e8 00 02 00 00       	call   2fa <printf>
  fa:	83 c4 10             	add    $0x10,%esp
  for(; n > 0; n--)
  fd:	4e                   	dec    %esi
  fe:	85 f6                	test   %esi,%esi
 100:	7e 46                	jle    148 <forktest+0x148>
    if((pid = wait(&status)) < 0)
 102:	83 ec 0c             	sub    $0xc,%esp
 105:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 108:	50                   	push   %eax
 109:	e8 b5 00 00 00       	call   1c3 <wait>
 10e:	89 c7                	mov    %eax,%edi
 110:	83 c4 10             	add    $0x10,%esp
 113:	85 c0                	test   %eax,%eax
 115:	0f 88 6e ff ff ff    	js     89 <forktest+0x89>
    printf(1, "status waitexit: ");
 11b:	83 ec 08             	sub    $0x8,%esp
 11e:	68 84 04 00 00       	push   $0x484
 123:	6a 01                	push   $0x1
 125:	e8 d0 01 00 00       	call   2fa <printf>
    for(int i = 15; i >= 0; i--){
 12a:	83 c4 10             	add    $0x10,%esp
 12d:	bb 0f 00 00 00       	mov    $0xf,%ebx
 132:	eb 83                	jmp    b7 <forktest+0xb7>
    else if (WIFSIGNALED(status))
      printf (1, "Exited child (failure) %d, trap %d\n", pid, WEXITTRAP (status));
 134:	4a                   	dec    %edx
 135:	52                   	push   %edx
 136:	57                   	push   %edi
 137:	68 f8 04 00 00       	push   $0x4f8
 13c:	6a 01                	push   $0x1
 13e:	e8 b7 01 00 00       	call   2fa <printf>
 143:	83 c4 10             	add    $0x10,%esp
 146:	eb b5                	jmp    fd <forktest+0xfd>
  }

  if(wait(0) != -1){
 148:	83 ec 0c             	sub    $0xc,%esp
 14b:	6a 00                	push   $0x0
 14d:	e8 71 00 00 00       	call   1c3 <wait>
 152:	83 c4 10             	add    $0x10,%esp
 155:	83 f8 ff             	cmp    $0xffffffff,%eax
 158:	75 1a                	jne    174 <forktest+0x174>
    printf(1, "wait got too many\n");
    exit(-1);
  }

  printf(1, "fork test OK\n");
 15a:	83 ec 08             	sub    $0x8,%esp
 15d:	68 ca 04 00 00       	push   $0x4ca
 162:	6a 01                	push   $0x1
 164:	e8 91 01 00 00       	call   2fa <printf>
}
 169:	83 c4 10             	add    $0x10,%esp
 16c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 16f:	5b                   	pop    %ebx
 170:	5e                   	pop    %esi
 171:	5f                   	pop    %edi
 172:	5d                   	pop    %ebp
 173:	c3                   	ret    
    printf(1, "wait got too many\n");
 174:	83 ec 08             	sub    $0x8,%esp
 177:	68 b7 04 00 00       	push   $0x4b7
 17c:	6a 01                	push   $0x1
 17e:	e8 77 01 00 00       	call   2fa <printf>
    exit(-1);
 183:	c7 04 24 ff ff ff ff 	movl   $0xffffffff,(%esp)
 18a:	e8 2c 00 00 00       	call   1bb <exit>

0000018f <main>:

int
main(void)
{
 18f:	f3 0f 1e fb          	endbr32 
 193:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 197:	83 e4 f0             	and    $0xfffffff0,%esp
 19a:	ff 71 fc             	pushl  -0x4(%ecx)
 19d:	55                   	push   %ebp
 19e:	89 e5                	mov    %esp,%ebp
 1a0:	51                   	push   %ecx
 1a1:	83 ec 04             	sub    $0x4,%esp
  forktest();
 1a4:	e8 57 fe ff ff       	call   0 <forktest>
  exit(0);
 1a9:	83 ec 0c             	sub    $0xc,%esp
 1ac:	6a 00                	push   $0x0
 1ae:	e8 08 00 00 00       	call   1bb <exit>

000001b3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 1b3:	b8 01 00 00 00       	mov    $0x1,%eax
 1b8:	cd 40                	int    $0x40
 1ba:	c3                   	ret    

000001bb <exit>:
SYSCALL(exit)
 1bb:	b8 02 00 00 00       	mov    $0x2,%eax
 1c0:	cd 40                	int    $0x40
 1c2:	c3                   	ret    

000001c3 <wait>:
SYSCALL(wait)
 1c3:	b8 03 00 00 00       	mov    $0x3,%eax
 1c8:	cd 40                	int    $0x40
 1ca:	c3                   	ret    

000001cb <pipe>:
SYSCALL(pipe)
 1cb:	b8 04 00 00 00       	mov    $0x4,%eax
 1d0:	cd 40                	int    $0x40
 1d2:	c3                   	ret    

000001d3 <read>:
SYSCALL(read)
 1d3:	b8 05 00 00 00       	mov    $0x5,%eax
 1d8:	cd 40                	int    $0x40
 1da:	c3                   	ret    

000001db <write>:
SYSCALL(write)
 1db:	b8 10 00 00 00       	mov    $0x10,%eax
 1e0:	cd 40                	int    $0x40
 1e2:	c3                   	ret    

000001e3 <close>:
SYSCALL(close)
 1e3:	b8 15 00 00 00       	mov    $0x15,%eax
 1e8:	cd 40                	int    $0x40
 1ea:	c3                   	ret    

000001eb <kill>:
SYSCALL(kill)
 1eb:	b8 06 00 00 00       	mov    $0x6,%eax
 1f0:	cd 40                	int    $0x40
 1f2:	c3                   	ret    

000001f3 <exec>:
SYSCALL(exec)
 1f3:	b8 07 00 00 00       	mov    $0x7,%eax
 1f8:	cd 40                	int    $0x40
 1fa:	c3                   	ret    

000001fb <open>:
SYSCALL(open)
 1fb:	b8 0f 00 00 00       	mov    $0xf,%eax
 200:	cd 40                	int    $0x40
 202:	c3                   	ret    

00000203 <mknod>:
SYSCALL(mknod)
 203:	b8 11 00 00 00       	mov    $0x11,%eax
 208:	cd 40                	int    $0x40
 20a:	c3                   	ret    

0000020b <unlink>:
SYSCALL(unlink)
 20b:	b8 12 00 00 00       	mov    $0x12,%eax
 210:	cd 40                	int    $0x40
 212:	c3                   	ret    

00000213 <fstat>:
SYSCALL(fstat)
 213:	b8 08 00 00 00       	mov    $0x8,%eax
 218:	cd 40                	int    $0x40
 21a:	c3                   	ret    

0000021b <link>:
SYSCALL(link)
 21b:	b8 13 00 00 00       	mov    $0x13,%eax
 220:	cd 40                	int    $0x40
 222:	c3                   	ret    

00000223 <mkdir>:
SYSCALL(mkdir)
 223:	b8 14 00 00 00       	mov    $0x14,%eax
 228:	cd 40                	int    $0x40
 22a:	c3                   	ret    

0000022b <chdir>:
SYSCALL(chdir)
 22b:	b8 09 00 00 00       	mov    $0x9,%eax
 230:	cd 40                	int    $0x40
 232:	c3                   	ret    

00000233 <dup>:
SYSCALL(dup)
 233:	b8 0a 00 00 00       	mov    $0xa,%eax
 238:	cd 40                	int    $0x40
 23a:	c3                   	ret    

0000023b <getpid>:
SYSCALL(getpid)
 23b:	b8 0b 00 00 00       	mov    $0xb,%eax
 240:	cd 40                	int    $0x40
 242:	c3                   	ret    

00000243 <sbrk>:
SYSCALL(sbrk)
 243:	b8 0c 00 00 00       	mov    $0xc,%eax
 248:	cd 40                	int    $0x40
 24a:	c3                   	ret    

0000024b <sleep>:
SYSCALL(sleep)
 24b:	b8 0d 00 00 00       	mov    $0xd,%eax
 250:	cd 40                	int    $0x40
 252:	c3                   	ret    

00000253 <uptime>:
SYSCALL(uptime)
 253:	b8 0e 00 00 00       	mov    $0xe,%eax
 258:	cd 40                	int    $0x40
 25a:	c3                   	ret    

0000025b <date>:
SYSCALL(date)
 25b:	b8 16 00 00 00       	mov    $0x16,%eax
 260:	cd 40                	int    $0x40
 262:	c3                   	ret    

00000263 <dup2>:
 263:	b8 17 00 00 00       	mov    $0x17,%eax
 268:	cd 40                	int    $0x40
 26a:	c3                   	ret    

0000026b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 26b:	55                   	push   %ebp
 26c:	89 e5                	mov    %esp,%ebp
 26e:	83 ec 1c             	sub    $0x1c,%esp
 271:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 274:	6a 01                	push   $0x1
 276:	8d 55 f4             	lea    -0xc(%ebp),%edx
 279:	52                   	push   %edx
 27a:	50                   	push   %eax
 27b:	e8 5b ff ff ff       	call   1db <write>
}
 280:	83 c4 10             	add    $0x10,%esp
 283:	c9                   	leave  
 284:	c3                   	ret    

00000285 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 285:	55                   	push   %ebp
 286:	89 e5                	mov    %esp,%ebp
 288:	57                   	push   %edi
 289:	56                   	push   %esi
 28a:	53                   	push   %ebx
 28b:	83 ec 2c             	sub    $0x2c,%esp
 28e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 291:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 293:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 297:	74 04                	je     29d <printint+0x18>
 299:	85 d2                	test   %edx,%edx
 29b:	78 3a                	js     2d7 <printint+0x52>
  neg = 0;
 29d:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 2a4:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 2a9:	89 f0                	mov    %esi,%eax
 2ab:	ba 00 00 00 00       	mov    $0x0,%edx
 2b0:	f7 f1                	div    %ecx
 2b2:	89 df                	mov    %ebx,%edi
 2b4:	43                   	inc    %ebx
 2b5:	8a 92 24 05 00 00    	mov    0x524(%edx),%dl
 2bb:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 2bf:	89 f2                	mov    %esi,%edx
 2c1:	89 c6                	mov    %eax,%esi
 2c3:	39 d1                	cmp    %edx,%ecx
 2c5:	76 e2                	jbe    2a9 <printint+0x24>
  if(neg)
 2c7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 2cb:	74 22                	je     2ef <printint+0x6a>
    buf[i++] = '-';
 2cd:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 2d2:	8d 5f 02             	lea    0x2(%edi),%ebx
 2d5:	eb 18                	jmp    2ef <printint+0x6a>
    x = -xx;
 2d7:	f7 de                	neg    %esi
    neg = 1;
 2d9:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 2e0:	eb c2                	jmp    2a4 <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 2e2:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 2e7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 2ea:	e8 7c ff ff ff       	call   26b <putc>
  while(--i >= 0)
 2ef:	4b                   	dec    %ebx
 2f0:	79 f0                	jns    2e2 <printint+0x5d>
}
 2f2:	83 c4 2c             	add    $0x2c,%esp
 2f5:	5b                   	pop    %ebx
 2f6:	5e                   	pop    %esi
 2f7:	5f                   	pop    %edi
 2f8:	5d                   	pop    %ebp
 2f9:	c3                   	ret    

000002fa <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 2fa:	f3 0f 1e fb          	endbr32 
 2fe:	55                   	push   %ebp
 2ff:	89 e5                	mov    %esp,%ebp
 301:	57                   	push   %edi
 302:	56                   	push   %esi
 303:	53                   	push   %ebx
 304:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 307:	8d 45 10             	lea    0x10(%ebp),%eax
 30a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 30d:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 312:	bb 00 00 00 00       	mov    $0x0,%ebx
 317:	eb 12                	jmp    32b <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 319:	89 fa                	mov    %edi,%edx
 31b:	8b 45 08             	mov    0x8(%ebp),%eax
 31e:	e8 48 ff ff ff       	call   26b <putc>
 323:	eb 05                	jmp    32a <printf+0x30>
      }
    } else if(state == '%'){
 325:	83 fe 25             	cmp    $0x25,%esi
 328:	74 22                	je     34c <printf+0x52>
  for(i = 0; fmt[i]; i++){
 32a:	43                   	inc    %ebx
 32b:	8b 45 0c             	mov    0xc(%ebp),%eax
 32e:	8a 04 18             	mov    (%eax,%ebx,1),%al
 331:	84 c0                	test   %al,%al
 333:	0f 84 13 01 00 00    	je     44c <printf+0x152>
    c = fmt[i] & 0xff;
 339:	0f be f8             	movsbl %al,%edi
 33c:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 33f:	85 f6                	test   %esi,%esi
 341:	75 e2                	jne    325 <printf+0x2b>
      if(c == '%'){
 343:	83 f8 25             	cmp    $0x25,%eax
 346:	75 d1                	jne    319 <printf+0x1f>
        state = '%';
 348:	89 c6                	mov    %eax,%esi
 34a:	eb de                	jmp    32a <printf+0x30>
      if(c == 'd'){
 34c:	83 f8 64             	cmp    $0x64,%eax
 34f:	74 43                	je     394 <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 351:	83 f8 78             	cmp    $0x78,%eax
 354:	74 68                	je     3be <printf+0xc4>
 356:	83 f8 70             	cmp    $0x70,%eax
 359:	74 63                	je     3be <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 35b:	83 f8 73             	cmp    $0x73,%eax
 35e:	0f 84 84 00 00 00    	je     3e8 <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 364:	83 f8 63             	cmp    $0x63,%eax
 367:	0f 84 ad 00 00 00    	je     41a <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 36d:	83 f8 25             	cmp    $0x25,%eax
 370:	0f 84 c2 00 00 00    	je     438 <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 376:	ba 25 00 00 00       	mov    $0x25,%edx
 37b:	8b 45 08             	mov    0x8(%ebp),%eax
 37e:	e8 e8 fe ff ff       	call   26b <putc>
        putc(fd, c);
 383:	89 fa                	mov    %edi,%edx
 385:	8b 45 08             	mov    0x8(%ebp),%eax
 388:	e8 de fe ff ff       	call   26b <putc>
      }
      state = 0;
 38d:	be 00 00 00 00       	mov    $0x0,%esi
 392:	eb 96                	jmp    32a <printf+0x30>
        printint(fd, *ap, 10, 1);
 394:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 397:	8b 17                	mov    (%edi),%edx
 399:	83 ec 0c             	sub    $0xc,%esp
 39c:	6a 01                	push   $0x1
 39e:	b9 0a 00 00 00       	mov    $0xa,%ecx
 3a3:	8b 45 08             	mov    0x8(%ebp),%eax
 3a6:	e8 da fe ff ff       	call   285 <printint>
        ap++;
 3ab:	83 c7 04             	add    $0x4,%edi
 3ae:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3b1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 3b4:	be 00 00 00 00       	mov    $0x0,%esi
 3b9:	e9 6c ff ff ff       	jmp    32a <printf+0x30>
        printint(fd, *ap, 16, 0);
 3be:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 3c1:	8b 17                	mov    (%edi),%edx
 3c3:	83 ec 0c             	sub    $0xc,%esp
 3c6:	6a 00                	push   $0x0
 3c8:	b9 10 00 00 00       	mov    $0x10,%ecx
 3cd:	8b 45 08             	mov    0x8(%ebp),%eax
 3d0:	e8 b0 fe ff ff       	call   285 <printint>
        ap++;
 3d5:	83 c7 04             	add    $0x4,%edi
 3d8:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 3db:	83 c4 10             	add    $0x10,%esp
      state = 0;
 3de:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 3e3:	e9 42 ff ff ff       	jmp    32a <printf+0x30>
        s = (char*)*ap;
 3e8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 3eb:	8b 30                	mov    (%eax),%esi
        ap++;
 3ed:	83 c0 04             	add    $0x4,%eax
 3f0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 3f3:	85 f6                	test   %esi,%esi
 3f5:	75 13                	jne    40a <printf+0x110>
          s = "(null)";
 3f7:	be 1c 05 00 00       	mov    $0x51c,%esi
 3fc:	eb 0c                	jmp    40a <printf+0x110>
          putc(fd, *s);
 3fe:	0f be d2             	movsbl %dl,%edx
 401:	8b 45 08             	mov    0x8(%ebp),%eax
 404:	e8 62 fe ff ff       	call   26b <putc>
          s++;
 409:	46                   	inc    %esi
        while(*s != 0){
 40a:	8a 16                	mov    (%esi),%dl
 40c:	84 d2                	test   %dl,%dl
 40e:	75 ee                	jne    3fe <printf+0x104>
      state = 0;
 410:	be 00 00 00 00       	mov    $0x0,%esi
 415:	e9 10 ff ff ff       	jmp    32a <printf+0x30>
        putc(fd, *ap);
 41a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 41d:	0f be 17             	movsbl (%edi),%edx
 420:	8b 45 08             	mov    0x8(%ebp),%eax
 423:	e8 43 fe ff ff       	call   26b <putc>
        ap++;
 428:	83 c7 04             	add    $0x4,%edi
 42b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 42e:	be 00 00 00 00       	mov    $0x0,%esi
 433:	e9 f2 fe ff ff       	jmp    32a <printf+0x30>
        putc(fd, c);
 438:	89 fa                	mov    %edi,%edx
 43a:	8b 45 08             	mov    0x8(%ebp),%eax
 43d:	e8 29 fe ff ff       	call   26b <putc>
      state = 0;
 442:	be 00 00 00 00       	mov    $0x0,%esi
 447:	e9 de fe ff ff       	jmp    32a <printf+0x30>
    }
  }
}
 44c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 44f:	5b                   	pop    %ebx
 450:	5e                   	pop    %esi
 451:	5f                   	pop    %edi
 452:	5d                   	pop    %ebp
 453:	c3                   	ret    
