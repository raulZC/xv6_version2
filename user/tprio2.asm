
tprio2:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "types.h"
#include "user.h"

int
main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	56                   	push   %esi
  12:	53                   	push   %ebx
  13:	51                   	push   %ecx
  14:	83 ec 0c             	sub    $0xc,%esp
  // Padre termina
  if (fork() != 0)
  17:	e8 5f 00 00 00       	call   7b <fork>
  1c:	85 c0                	test   %eax,%eax
  1e:	74 0a                	je     2a <main+0x2a>
    exit(0);
  20:	83 ec 0c             	sub    $0xc,%esp
  23:	6a 00                	push   $0x0
  25:	e8 59 00 00 00       	call   83 <exit>
  2a:	89 c3                	mov    %eax,%ebx
  
  // Establecer prioridad normal. El shell aparecerá normalmente.
  setprio (getpid(), NORM_PRIO);
  2c:	e8 d2 00 00 00       	call   103 <getpid>
  31:	83 ec 08             	sub    $0x8,%esp
  34:	6a 00                	push   $0x0
  36:	50                   	push   %eax
  37:	e8 ff 00 00 00       	call   13b <setprio>

  int r = 0;
  
  for (int i = 0; i < 2000; ++i)
  3c:	83 c4 10             	add    $0x10,%esp
  3f:	89 de                	mov    %ebx,%esi
  int r = 0;
  41:	89 da                	mov    %ebx,%edx
  for (int i = 0; i < 2000; ++i)
  43:	eb 01                	jmp    46 <main+0x46>
  45:	46                   	inc    %esi
  46:	81 fe cf 07 00 00    	cmp    $0x7cf,%esi
  4c:	7f 11                	jg     5f <main+0x5f>
    for (int j = 0; j < 1000000; ++j)
  4e:	89 d8                	mov    %ebx,%eax
  50:	3d 3f 42 0f 00       	cmp    $0xf423f,%eax
  55:	7f ee                	jg     45 <main+0x45>
      r += i + j;
  57:	8d 0c 06             	lea    (%esi,%eax,1),%ecx
  5a:	01 ca                	add    %ecx,%edx
    for (int j = 0; j < 1000000; ++j)
  5c:	40                   	inc    %eax
  5d:	eb f1                	jmp    50 <main+0x50>

  // Imprime el resultado
  printf (1, "Resultado: %d\n", r);
  5f:	83 ec 04             	sub    $0x4,%esp
  62:	52                   	push   %edx
  63:	68 2c 03 00 00       	push   $0x32c
  68:	6a 01                	push   $0x1
  6a:	e8 63 01 00 00       	call   1d2 <printf>
  
  exit(0);
  6f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  76:	e8 08 00 00 00       	call   83 <exit>

0000007b <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  7b:	b8 01 00 00 00       	mov    $0x1,%eax
  80:	cd 40                	int    $0x40
  82:	c3                   	ret    

00000083 <exit>:
SYSCALL(exit)
  83:	b8 02 00 00 00       	mov    $0x2,%eax
  88:	cd 40                	int    $0x40
  8a:	c3                   	ret    

0000008b <wait>:
SYSCALL(wait)
  8b:	b8 03 00 00 00       	mov    $0x3,%eax
  90:	cd 40                	int    $0x40
  92:	c3                   	ret    

00000093 <pipe>:
SYSCALL(pipe)
  93:	b8 04 00 00 00       	mov    $0x4,%eax
  98:	cd 40                	int    $0x40
  9a:	c3                   	ret    

0000009b <read>:
SYSCALL(read)
  9b:	b8 05 00 00 00       	mov    $0x5,%eax
  a0:	cd 40                	int    $0x40
  a2:	c3                   	ret    

000000a3 <write>:
SYSCALL(write)
  a3:	b8 10 00 00 00       	mov    $0x10,%eax
  a8:	cd 40                	int    $0x40
  aa:	c3                   	ret    

000000ab <close>:
SYSCALL(close)
  ab:	b8 15 00 00 00       	mov    $0x15,%eax
  b0:	cd 40                	int    $0x40
  b2:	c3                   	ret    

000000b3 <kill>:
SYSCALL(kill)
  b3:	b8 06 00 00 00       	mov    $0x6,%eax
  b8:	cd 40                	int    $0x40
  ba:	c3                   	ret    

000000bb <exec>:
SYSCALL(exec)
  bb:	b8 07 00 00 00       	mov    $0x7,%eax
  c0:	cd 40                	int    $0x40
  c2:	c3                   	ret    

000000c3 <open>:
SYSCALL(open)
  c3:	b8 0f 00 00 00       	mov    $0xf,%eax
  c8:	cd 40                	int    $0x40
  ca:	c3                   	ret    

000000cb <mknod>:
SYSCALL(mknod)
  cb:	b8 11 00 00 00       	mov    $0x11,%eax
  d0:	cd 40                	int    $0x40
  d2:	c3                   	ret    

000000d3 <unlink>:
SYSCALL(unlink)
  d3:	b8 12 00 00 00       	mov    $0x12,%eax
  d8:	cd 40                	int    $0x40
  da:	c3                   	ret    

000000db <fstat>:
SYSCALL(fstat)
  db:	b8 08 00 00 00       	mov    $0x8,%eax
  e0:	cd 40                	int    $0x40
  e2:	c3                   	ret    

000000e3 <link>:
SYSCALL(link)
  e3:	b8 13 00 00 00       	mov    $0x13,%eax
  e8:	cd 40                	int    $0x40
  ea:	c3                   	ret    

000000eb <mkdir>:
SYSCALL(mkdir)
  eb:	b8 14 00 00 00       	mov    $0x14,%eax
  f0:	cd 40                	int    $0x40
  f2:	c3                   	ret    

000000f3 <chdir>:
SYSCALL(chdir)
  f3:	b8 09 00 00 00       	mov    $0x9,%eax
  f8:	cd 40                	int    $0x40
  fa:	c3                   	ret    

000000fb <dup>:
SYSCALL(dup)
  fb:	b8 0a 00 00 00       	mov    $0xa,%eax
 100:	cd 40                	int    $0x40
 102:	c3                   	ret    

00000103 <getpid>:
SYSCALL(getpid)
 103:	b8 0b 00 00 00       	mov    $0xb,%eax
 108:	cd 40                	int    $0x40
 10a:	c3                   	ret    

0000010b <sbrk>:
SYSCALL(sbrk)
 10b:	b8 0c 00 00 00       	mov    $0xc,%eax
 110:	cd 40                	int    $0x40
 112:	c3                   	ret    

00000113 <sleep>:
SYSCALL(sleep)
 113:	b8 0d 00 00 00       	mov    $0xd,%eax
 118:	cd 40                	int    $0x40
 11a:	c3                   	ret    

0000011b <uptime>:
SYSCALL(uptime)
 11b:	b8 0e 00 00 00       	mov    $0xe,%eax
 120:	cd 40                	int    $0x40
 122:	c3                   	ret    

00000123 <date>:
SYSCALL(date)
 123:	b8 16 00 00 00       	mov    $0x16,%eax
 128:	cd 40                	int    $0x40
 12a:	c3                   	ret    

0000012b <dup2>:
SYSCALL(dup2)
 12b:	b8 17 00 00 00       	mov    $0x17,%eax
 130:	cd 40                	int    $0x40
 132:	c3                   	ret    

00000133 <getprio>:
SYSCALL(getprio)
 133:	b8 18 00 00 00       	mov    $0x18,%eax
 138:	cd 40                	int    $0x40
 13a:	c3                   	ret    

0000013b <setprio>:
 13b:	b8 19 00 00 00       	mov    $0x19,%eax
 140:	cd 40                	int    $0x40
 142:	c3                   	ret    

00000143 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 143:	55                   	push   %ebp
 144:	89 e5                	mov    %esp,%ebp
 146:	83 ec 1c             	sub    $0x1c,%esp
 149:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 14c:	6a 01                	push   $0x1
 14e:	8d 55 f4             	lea    -0xc(%ebp),%edx
 151:	52                   	push   %edx
 152:	50                   	push   %eax
 153:	e8 4b ff ff ff       	call   a3 <write>
}
 158:	83 c4 10             	add    $0x10,%esp
 15b:	c9                   	leave  
 15c:	c3                   	ret    

0000015d <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 15d:	55                   	push   %ebp
 15e:	89 e5                	mov    %esp,%ebp
 160:	57                   	push   %edi
 161:	56                   	push   %esi
 162:	53                   	push   %ebx
 163:	83 ec 2c             	sub    $0x2c,%esp
 166:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 169:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 16b:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 16f:	74 04                	je     175 <printint+0x18>
 171:	85 d2                	test   %edx,%edx
 173:	78 3a                	js     1af <printint+0x52>
  neg = 0;
 175:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 17c:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 181:	89 f0                	mov    %esi,%eax
 183:	ba 00 00 00 00       	mov    $0x0,%edx
 188:	f7 f1                	div    %ecx
 18a:	89 df                	mov    %ebx,%edi
 18c:	43                   	inc    %ebx
 18d:	8a 92 44 03 00 00    	mov    0x344(%edx),%dl
 193:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 197:	89 f2                	mov    %esi,%edx
 199:	89 c6                	mov    %eax,%esi
 19b:	39 d1                	cmp    %edx,%ecx
 19d:	76 e2                	jbe    181 <printint+0x24>
  if(neg)
 19f:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 1a3:	74 22                	je     1c7 <printint+0x6a>
    buf[i++] = '-';
 1a5:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 1aa:	8d 5f 02             	lea    0x2(%edi),%ebx
 1ad:	eb 18                	jmp    1c7 <printint+0x6a>
    x = -xx;
 1af:	f7 de                	neg    %esi
    neg = 1;
 1b1:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 1b8:	eb c2                	jmp    17c <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 1ba:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 1bf:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1c2:	e8 7c ff ff ff       	call   143 <putc>
  while(--i >= 0)
 1c7:	4b                   	dec    %ebx
 1c8:	79 f0                	jns    1ba <printint+0x5d>
}
 1ca:	83 c4 2c             	add    $0x2c,%esp
 1cd:	5b                   	pop    %ebx
 1ce:	5e                   	pop    %esi
 1cf:	5f                   	pop    %edi
 1d0:	5d                   	pop    %ebp
 1d1:	c3                   	ret    

000001d2 <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 1d2:	f3 0f 1e fb          	endbr32 
 1d6:	55                   	push   %ebp
 1d7:	89 e5                	mov    %esp,%ebp
 1d9:	57                   	push   %edi
 1da:	56                   	push   %esi
 1db:	53                   	push   %ebx
 1dc:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 1df:	8d 45 10             	lea    0x10(%ebp),%eax
 1e2:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 1e5:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 1ea:	bb 00 00 00 00       	mov    $0x0,%ebx
 1ef:	eb 12                	jmp    203 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 1f1:	89 fa                	mov    %edi,%edx
 1f3:	8b 45 08             	mov    0x8(%ebp),%eax
 1f6:	e8 48 ff ff ff       	call   143 <putc>
 1fb:	eb 05                	jmp    202 <printf+0x30>
      }
    } else if(state == '%'){
 1fd:	83 fe 25             	cmp    $0x25,%esi
 200:	74 22                	je     224 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 202:	43                   	inc    %ebx
 203:	8b 45 0c             	mov    0xc(%ebp),%eax
 206:	8a 04 18             	mov    (%eax,%ebx,1),%al
 209:	84 c0                	test   %al,%al
 20b:	0f 84 13 01 00 00    	je     324 <printf+0x152>
    c = fmt[i] & 0xff;
 211:	0f be f8             	movsbl %al,%edi
 214:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 217:	85 f6                	test   %esi,%esi
 219:	75 e2                	jne    1fd <printf+0x2b>
      if(c == '%'){
 21b:	83 f8 25             	cmp    $0x25,%eax
 21e:	75 d1                	jne    1f1 <printf+0x1f>
        state = '%';
 220:	89 c6                	mov    %eax,%esi
 222:	eb de                	jmp    202 <printf+0x30>
      if(c == 'd'){
 224:	83 f8 64             	cmp    $0x64,%eax
 227:	74 43                	je     26c <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 229:	83 f8 78             	cmp    $0x78,%eax
 22c:	74 68                	je     296 <printf+0xc4>
 22e:	83 f8 70             	cmp    $0x70,%eax
 231:	74 63                	je     296 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 233:	83 f8 73             	cmp    $0x73,%eax
 236:	0f 84 84 00 00 00    	je     2c0 <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 23c:	83 f8 63             	cmp    $0x63,%eax
 23f:	0f 84 ad 00 00 00    	je     2f2 <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 245:	83 f8 25             	cmp    $0x25,%eax
 248:	0f 84 c2 00 00 00    	je     310 <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 24e:	ba 25 00 00 00       	mov    $0x25,%edx
 253:	8b 45 08             	mov    0x8(%ebp),%eax
 256:	e8 e8 fe ff ff       	call   143 <putc>
        putc(fd, c);
 25b:	89 fa                	mov    %edi,%edx
 25d:	8b 45 08             	mov    0x8(%ebp),%eax
 260:	e8 de fe ff ff       	call   143 <putc>
      }
      state = 0;
 265:	be 00 00 00 00       	mov    $0x0,%esi
 26a:	eb 96                	jmp    202 <printf+0x30>
        printint(fd, *ap, 10, 1);
 26c:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 26f:	8b 17                	mov    (%edi),%edx
 271:	83 ec 0c             	sub    $0xc,%esp
 274:	6a 01                	push   $0x1
 276:	b9 0a 00 00 00       	mov    $0xa,%ecx
 27b:	8b 45 08             	mov    0x8(%ebp),%eax
 27e:	e8 da fe ff ff       	call   15d <printint>
        ap++;
 283:	83 c7 04             	add    $0x4,%edi
 286:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 289:	83 c4 10             	add    $0x10,%esp
      state = 0;
 28c:	be 00 00 00 00       	mov    $0x0,%esi
 291:	e9 6c ff ff ff       	jmp    202 <printf+0x30>
        printint(fd, *ap, 16, 0);
 296:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 299:	8b 17                	mov    (%edi),%edx
 29b:	83 ec 0c             	sub    $0xc,%esp
 29e:	6a 00                	push   $0x0
 2a0:	b9 10 00 00 00       	mov    $0x10,%ecx
 2a5:	8b 45 08             	mov    0x8(%ebp),%eax
 2a8:	e8 b0 fe ff ff       	call   15d <printint>
        ap++;
 2ad:	83 c7 04             	add    $0x4,%edi
 2b0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2b3:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2b6:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 2bb:	e9 42 ff ff ff       	jmp    202 <printf+0x30>
        s = (char*)*ap;
 2c0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2c3:	8b 30                	mov    (%eax),%esi
        ap++;
 2c5:	83 c0 04             	add    $0x4,%eax
 2c8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 2cb:	85 f6                	test   %esi,%esi
 2cd:	75 13                	jne    2e2 <printf+0x110>
          s = "(null)";
 2cf:	be 3b 03 00 00       	mov    $0x33b,%esi
 2d4:	eb 0c                	jmp    2e2 <printf+0x110>
          putc(fd, *s);
 2d6:	0f be d2             	movsbl %dl,%edx
 2d9:	8b 45 08             	mov    0x8(%ebp),%eax
 2dc:	e8 62 fe ff ff       	call   143 <putc>
          s++;
 2e1:	46                   	inc    %esi
        while(*s != 0){
 2e2:	8a 16                	mov    (%esi),%dl
 2e4:	84 d2                	test   %dl,%dl
 2e6:	75 ee                	jne    2d6 <printf+0x104>
      state = 0;
 2e8:	be 00 00 00 00       	mov    $0x0,%esi
 2ed:	e9 10 ff ff ff       	jmp    202 <printf+0x30>
        putc(fd, *ap);
 2f2:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2f5:	0f be 17             	movsbl (%edi),%edx
 2f8:	8b 45 08             	mov    0x8(%ebp),%eax
 2fb:	e8 43 fe ff ff       	call   143 <putc>
        ap++;
 300:	83 c7 04             	add    $0x4,%edi
 303:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 306:	be 00 00 00 00       	mov    $0x0,%esi
 30b:	e9 f2 fe ff ff       	jmp    202 <printf+0x30>
        putc(fd, c);
 310:	89 fa                	mov    %edi,%edx
 312:	8b 45 08             	mov    0x8(%ebp),%eax
 315:	e8 29 fe ff ff       	call   143 <putc>
      state = 0;
 31a:	be 00 00 00 00       	mov    $0x0,%esi
 31f:	e9 de fe ff ff       	jmp    202 <printf+0x30>
    }
  }
}
 324:	8d 65 f4             	lea    -0xc(%ebp),%esp
 327:	5b                   	pop    %ebx
 328:	5e                   	pop    %esi
 329:	5f                   	pop    %edi
 32a:	5d                   	pop    %ebp
 32b:	c3                   	ret    
