
date:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <main>:
#include "types.h"
#include "user.h"
#include "date.h"
int main(int argc, char *argv[])
{
   0:	f3 0f 1e fb          	endbr32 
   4:	8d 4c 24 04          	lea    0x4(%esp),%ecx
   8:	83 e4 f0             	and    $0xfffffff0,%esp
   b:	ff 71 fc             	pushl  -0x4(%ecx)
   e:	55                   	push   %ebp
   f:	89 e5                	mov    %esp,%ebp
  11:	51                   	push   %ecx
  12:	83 ec 30             	sub    $0x30,%esp
    struct rtcdate r;
    if (date(&r))
  15:	8d 45 e0             	lea    -0x20(%ebp),%eax
  18:	50                   	push   %eax
  19:	e8 f2 00 00 00       	call   110 <date>
  1e:	83 c4 10             	add    $0x10,%esp
  21:	85 c0                	test   %eax,%eax
  23:	74 1b                	je     40 <main+0x40>
    {
        printf(2, " date failed \n");
  25:	83 ec 08             	sub    $0x8,%esp
  28:	68 0c 03 00 00       	push   $0x30c
  2d:	6a 02                	push   $0x2
  2f:	e8 7b 01 00 00       	call   1af <printf>
        exit(0);
  34:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  3b:	e8 30 00 00 00       	call   70 <exit>
    }
    printf(1,"%d/%d/%d %d:%d:%d\n",r.day,r.month,r.year,r.hour,r.minute,r.second);
  40:	ff 75 e0             	pushl  -0x20(%ebp)
  43:	ff 75 e4             	pushl  -0x1c(%ebp)
  46:	ff 75 e8             	pushl  -0x18(%ebp)
  49:	ff 75 f4             	pushl  -0xc(%ebp)
  4c:	ff 75 f0             	pushl  -0x10(%ebp)
  4f:	ff 75 ec             	pushl  -0x14(%ebp)
  52:	68 1b 03 00 00       	push   $0x31b
  57:	6a 01                	push   $0x1
  59:	e8 51 01 00 00       	call   1af <printf>

    exit(0);
  5e:	83 c4 14             	add    $0x14,%esp
  61:	6a 00                	push   $0x0
  63:	e8 08 00 00 00       	call   70 <exit>

00000068 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  68:	b8 01 00 00 00       	mov    $0x1,%eax
  6d:	cd 40                	int    $0x40
  6f:	c3                   	ret    

00000070 <exit>:
SYSCALL(exit)
  70:	b8 02 00 00 00       	mov    $0x2,%eax
  75:	cd 40                	int    $0x40
  77:	c3                   	ret    

00000078 <wait>:
SYSCALL(wait)
  78:	b8 03 00 00 00       	mov    $0x3,%eax
  7d:	cd 40                	int    $0x40
  7f:	c3                   	ret    

00000080 <pipe>:
SYSCALL(pipe)
  80:	b8 04 00 00 00       	mov    $0x4,%eax
  85:	cd 40                	int    $0x40
  87:	c3                   	ret    

00000088 <read>:
SYSCALL(read)
  88:	b8 05 00 00 00       	mov    $0x5,%eax
  8d:	cd 40                	int    $0x40
  8f:	c3                   	ret    

00000090 <write>:
SYSCALL(write)
  90:	b8 10 00 00 00       	mov    $0x10,%eax
  95:	cd 40                	int    $0x40
  97:	c3                   	ret    

00000098 <close>:
SYSCALL(close)
  98:	b8 15 00 00 00       	mov    $0x15,%eax
  9d:	cd 40                	int    $0x40
  9f:	c3                   	ret    

000000a0 <kill>:
SYSCALL(kill)
  a0:	b8 06 00 00 00       	mov    $0x6,%eax
  a5:	cd 40                	int    $0x40
  a7:	c3                   	ret    

000000a8 <exec>:
SYSCALL(exec)
  a8:	b8 07 00 00 00       	mov    $0x7,%eax
  ad:	cd 40                	int    $0x40
  af:	c3                   	ret    

000000b0 <open>:
SYSCALL(open)
  b0:	b8 0f 00 00 00       	mov    $0xf,%eax
  b5:	cd 40                	int    $0x40
  b7:	c3                   	ret    

000000b8 <mknod>:
SYSCALL(mknod)
  b8:	b8 11 00 00 00       	mov    $0x11,%eax
  bd:	cd 40                	int    $0x40
  bf:	c3                   	ret    

000000c0 <unlink>:
SYSCALL(unlink)
  c0:	b8 12 00 00 00       	mov    $0x12,%eax
  c5:	cd 40                	int    $0x40
  c7:	c3                   	ret    

000000c8 <fstat>:
SYSCALL(fstat)
  c8:	b8 08 00 00 00       	mov    $0x8,%eax
  cd:	cd 40                	int    $0x40
  cf:	c3                   	ret    

000000d0 <link>:
SYSCALL(link)
  d0:	b8 13 00 00 00       	mov    $0x13,%eax
  d5:	cd 40                	int    $0x40
  d7:	c3                   	ret    

000000d8 <mkdir>:
SYSCALL(mkdir)
  d8:	b8 14 00 00 00       	mov    $0x14,%eax
  dd:	cd 40                	int    $0x40
  df:	c3                   	ret    

000000e0 <chdir>:
SYSCALL(chdir)
  e0:	b8 09 00 00 00       	mov    $0x9,%eax
  e5:	cd 40                	int    $0x40
  e7:	c3                   	ret    

000000e8 <dup>:
SYSCALL(dup)
  e8:	b8 0a 00 00 00       	mov    $0xa,%eax
  ed:	cd 40                	int    $0x40
  ef:	c3                   	ret    

000000f0 <getpid>:
SYSCALL(getpid)
  f0:	b8 0b 00 00 00       	mov    $0xb,%eax
  f5:	cd 40                	int    $0x40
  f7:	c3                   	ret    

000000f8 <sbrk>:
SYSCALL(sbrk)
  f8:	b8 0c 00 00 00       	mov    $0xc,%eax
  fd:	cd 40                	int    $0x40
  ff:	c3                   	ret    

00000100 <sleep>:
SYSCALL(sleep)
 100:	b8 0d 00 00 00       	mov    $0xd,%eax
 105:	cd 40                	int    $0x40
 107:	c3                   	ret    

00000108 <uptime>:
SYSCALL(uptime)
 108:	b8 0e 00 00 00       	mov    $0xe,%eax
 10d:	cd 40                	int    $0x40
 10f:	c3                   	ret    

00000110 <date>:
SYSCALL(date)
 110:	b8 16 00 00 00       	mov    $0x16,%eax
 115:	cd 40                	int    $0x40
 117:	c3                   	ret    

00000118 <dup2>:
 118:	b8 17 00 00 00       	mov    $0x17,%eax
 11d:	cd 40                	int    $0x40
 11f:	c3                   	ret    

00000120 <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 120:	55                   	push   %ebp
 121:	89 e5                	mov    %esp,%ebp
 123:	83 ec 1c             	sub    $0x1c,%esp
 126:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 129:	6a 01                	push   $0x1
 12b:	8d 55 f4             	lea    -0xc(%ebp),%edx
 12e:	52                   	push   %edx
 12f:	50                   	push   %eax
 130:	e8 5b ff ff ff       	call   90 <write>
}
 135:	83 c4 10             	add    $0x10,%esp
 138:	c9                   	leave  
 139:	c3                   	ret    

0000013a <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 13a:	55                   	push   %ebp
 13b:	89 e5                	mov    %esp,%ebp
 13d:	57                   	push   %edi
 13e:	56                   	push   %esi
 13f:	53                   	push   %ebx
 140:	83 ec 2c             	sub    $0x2c,%esp
 143:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 146:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 148:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 14c:	74 04                	je     152 <printint+0x18>
 14e:	85 d2                	test   %edx,%edx
 150:	78 3a                	js     18c <printint+0x52>
  neg = 0;
 152:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 159:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 15e:	89 f0                	mov    %esi,%eax
 160:	ba 00 00 00 00       	mov    $0x0,%edx
 165:	f7 f1                	div    %ecx
 167:	89 df                	mov    %ebx,%edi
 169:	43                   	inc    %ebx
 16a:	8a 92 38 03 00 00    	mov    0x338(%edx),%dl
 170:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 174:	89 f2                	mov    %esi,%edx
 176:	89 c6                	mov    %eax,%esi
 178:	39 d1                	cmp    %edx,%ecx
 17a:	76 e2                	jbe    15e <printint+0x24>
  if(neg)
 17c:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 180:	74 22                	je     1a4 <printint+0x6a>
    buf[i++] = '-';
 182:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 187:	8d 5f 02             	lea    0x2(%edi),%ebx
 18a:	eb 18                	jmp    1a4 <printint+0x6a>
    x = -xx;
 18c:	f7 de                	neg    %esi
    neg = 1;
 18e:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 195:	eb c2                	jmp    159 <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 197:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 19c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 19f:	e8 7c ff ff ff       	call   120 <putc>
  while(--i >= 0)
 1a4:	4b                   	dec    %ebx
 1a5:	79 f0                	jns    197 <printint+0x5d>
}
 1a7:	83 c4 2c             	add    $0x2c,%esp
 1aa:	5b                   	pop    %ebx
 1ab:	5e                   	pop    %esi
 1ac:	5f                   	pop    %edi
 1ad:	5d                   	pop    %ebp
 1ae:	c3                   	ret    

000001af <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 1af:	f3 0f 1e fb          	endbr32 
 1b3:	55                   	push   %ebp
 1b4:	89 e5                	mov    %esp,%ebp
 1b6:	57                   	push   %edi
 1b7:	56                   	push   %esi
 1b8:	53                   	push   %ebx
 1b9:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 1bc:	8d 45 10             	lea    0x10(%ebp),%eax
 1bf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 1c2:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 1c7:	bb 00 00 00 00       	mov    $0x0,%ebx
 1cc:	eb 12                	jmp    1e0 <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 1ce:	89 fa                	mov    %edi,%edx
 1d0:	8b 45 08             	mov    0x8(%ebp),%eax
 1d3:	e8 48 ff ff ff       	call   120 <putc>
 1d8:	eb 05                	jmp    1df <printf+0x30>
      }
    } else if(state == '%'){
 1da:	83 fe 25             	cmp    $0x25,%esi
 1dd:	74 22                	je     201 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 1df:	43                   	inc    %ebx
 1e0:	8b 45 0c             	mov    0xc(%ebp),%eax
 1e3:	8a 04 18             	mov    (%eax,%ebx,1),%al
 1e6:	84 c0                	test   %al,%al
 1e8:	0f 84 13 01 00 00    	je     301 <printf+0x152>
    c = fmt[i] & 0xff;
 1ee:	0f be f8             	movsbl %al,%edi
 1f1:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 1f4:	85 f6                	test   %esi,%esi
 1f6:	75 e2                	jne    1da <printf+0x2b>
      if(c == '%'){
 1f8:	83 f8 25             	cmp    $0x25,%eax
 1fb:	75 d1                	jne    1ce <printf+0x1f>
        state = '%';
 1fd:	89 c6                	mov    %eax,%esi
 1ff:	eb de                	jmp    1df <printf+0x30>
      if(c == 'd'){
 201:	83 f8 64             	cmp    $0x64,%eax
 204:	74 43                	je     249 <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 206:	83 f8 78             	cmp    $0x78,%eax
 209:	74 68                	je     273 <printf+0xc4>
 20b:	83 f8 70             	cmp    $0x70,%eax
 20e:	74 63                	je     273 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 210:	83 f8 73             	cmp    $0x73,%eax
 213:	0f 84 84 00 00 00    	je     29d <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 219:	83 f8 63             	cmp    $0x63,%eax
 21c:	0f 84 ad 00 00 00    	je     2cf <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 222:	83 f8 25             	cmp    $0x25,%eax
 225:	0f 84 c2 00 00 00    	je     2ed <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 22b:	ba 25 00 00 00       	mov    $0x25,%edx
 230:	8b 45 08             	mov    0x8(%ebp),%eax
 233:	e8 e8 fe ff ff       	call   120 <putc>
        putc(fd, c);
 238:	89 fa                	mov    %edi,%edx
 23a:	8b 45 08             	mov    0x8(%ebp),%eax
 23d:	e8 de fe ff ff       	call   120 <putc>
      }
      state = 0;
 242:	be 00 00 00 00       	mov    $0x0,%esi
 247:	eb 96                	jmp    1df <printf+0x30>
        printint(fd, *ap, 10, 1);
 249:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 24c:	8b 17                	mov    (%edi),%edx
 24e:	83 ec 0c             	sub    $0xc,%esp
 251:	6a 01                	push   $0x1
 253:	b9 0a 00 00 00       	mov    $0xa,%ecx
 258:	8b 45 08             	mov    0x8(%ebp),%eax
 25b:	e8 da fe ff ff       	call   13a <printint>
        ap++;
 260:	83 c7 04             	add    $0x4,%edi
 263:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 266:	83 c4 10             	add    $0x10,%esp
      state = 0;
 269:	be 00 00 00 00       	mov    $0x0,%esi
 26e:	e9 6c ff ff ff       	jmp    1df <printf+0x30>
        printint(fd, *ap, 16, 0);
 273:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 276:	8b 17                	mov    (%edi),%edx
 278:	83 ec 0c             	sub    $0xc,%esp
 27b:	6a 00                	push   $0x0
 27d:	b9 10 00 00 00       	mov    $0x10,%ecx
 282:	8b 45 08             	mov    0x8(%ebp),%eax
 285:	e8 b0 fe ff ff       	call   13a <printint>
        ap++;
 28a:	83 c7 04             	add    $0x4,%edi
 28d:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 290:	83 c4 10             	add    $0x10,%esp
      state = 0;
 293:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 298:	e9 42 ff ff ff       	jmp    1df <printf+0x30>
        s = (char*)*ap;
 29d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2a0:	8b 30                	mov    (%eax),%esi
        ap++;
 2a2:	83 c0 04             	add    $0x4,%eax
 2a5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 2a8:	85 f6                	test   %esi,%esi
 2aa:	75 13                	jne    2bf <printf+0x110>
          s = "(null)";
 2ac:	be 2e 03 00 00       	mov    $0x32e,%esi
 2b1:	eb 0c                	jmp    2bf <printf+0x110>
          putc(fd, *s);
 2b3:	0f be d2             	movsbl %dl,%edx
 2b6:	8b 45 08             	mov    0x8(%ebp),%eax
 2b9:	e8 62 fe ff ff       	call   120 <putc>
          s++;
 2be:	46                   	inc    %esi
        while(*s != 0){
 2bf:	8a 16                	mov    (%esi),%dl
 2c1:	84 d2                	test   %dl,%dl
 2c3:	75 ee                	jne    2b3 <printf+0x104>
      state = 0;
 2c5:	be 00 00 00 00       	mov    $0x0,%esi
 2ca:	e9 10 ff ff ff       	jmp    1df <printf+0x30>
        putc(fd, *ap);
 2cf:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2d2:	0f be 17             	movsbl (%edi),%edx
 2d5:	8b 45 08             	mov    0x8(%ebp),%eax
 2d8:	e8 43 fe ff ff       	call   120 <putc>
        ap++;
 2dd:	83 c7 04             	add    $0x4,%edi
 2e0:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 2e3:	be 00 00 00 00       	mov    $0x0,%esi
 2e8:	e9 f2 fe ff ff       	jmp    1df <printf+0x30>
        putc(fd, c);
 2ed:	89 fa                	mov    %edi,%edx
 2ef:	8b 45 08             	mov    0x8(%ebp),%eax
 2f2:	e8 29 fe ff ff       	call   120 <putc>
      state = 0;
 2f7:	be 00 00 00 00       	mov    $0x0,%esi
 2fc:	e9 de fe ff ff       	jmp    1df <printf+0x30>
    }
  }
}
 301:	8d 65 f4             	lea    -0xc(%ebp),%esp
 304:	5b                   	pop    %ebx
 305:	5e                   	pop    %esi
 306:	5f                   	pop    %edi
 307:	5d                   	pop    %ebp
 308:	c3                   	ret    
