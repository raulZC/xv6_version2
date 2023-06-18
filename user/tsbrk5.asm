
tsbrk5:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <test1>:
#include "user.h"

int i = 1;

void test1()
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	53                   	push   %ebx
   8:	83 ec 10             	sub    $0x10,%esp
  char* a = sbrk (0);
   b:	6a 00                	push   $0x0
   d:	e8 41 01 00 00       	call   153 <sbrk>
  12:	89 c3                	mov    %eax,%ebx

  printf (1, "Debe fallar ahora:\n");
  14:	83 c4 08             	add    $0x8,%esp
  17:	68 64 03 00 00       	push   $0x364
  1c:	6a 01                	push   $0x1
  1e:	e8 e7 01 00 00       	call   20a <printf>
  *(a+1) = 1;  // Debe fallar
  23:	c6 43 01 01          	movb   $0x1,0x1(%ebx)
}
  27:	83 c4 10             	add    $0x10,%esp
  2a:	8b 5d fc             	mov    -0x4(%ebp),%ebx
  2d:	c9                   	leave  
  2e:	c3                   	ret    

0000002f <test2>:

void test2()
{
  2f:	f3 0f 1e fb          	endbr32 
  33:	55                   	push   %ebp
  34:	89 e5                	mov    %esp,%ebp
  36:	83 ec 10             	sub    $0x10,%esp
  // Página de guarda:
  printf (1, "Si no fallo antes (mal), ahora tambien debe fallar:\n");
  39:	68 7c 03 00 00       	push   $0x37c
  3e:	6a 01                	push   $0x1
  40:	e8 c5 01 00 00       	call   20a <printf>
  char* a = (char*)((int)&i + 4095);
  printf (1, "%d\n", a);
  45:	83 c4 0c             	add    $0xc,%esp
  48:	68 23 15 00 00       	push   $0x1523
  4d:	68 78 03 00 00       	push   $0x378
  52:	6a 01                	push   $0x1
  54:	e8 b1 01 00 00       	call   20a <printf>
  *a = 1;
  59:	c6 05 23 15 00 00 01 	movb   $0x1,0x1523
}
  60:	83 c4 10             	add    $0x10,%esp
  63:	c9                   	leave  
  64:	c3                   	ret    

00000065 <test3>:

void test3()
{
  65:	f3 0f 1e fb          	endbr32 
  69:	55                   	push   %ebp
  6a:	89 e5                	mov    %esp,%ebp
  6c:	83 ec 10             	sub    $0x10,%esp
  // Acceder al núcleo
  printf (1, "Si no fallo antes (mal), ahora tambien debe fallar:\n");
  6f:	68 7c 03 00 00       	push   $0x37c
  74:	6a 01                	push   $0x1
  76:	e8 8f 01 00 00       	call   20a <printf>
  char* a = (char*)0x80000001;
  *(a+1) = 1;  // Debe fallar (si lo anterior no ha fallado)
  7b:	c6 05 02 00 00 80 01 	movb   $0x1,0x80000002
}
  82:	83 c4 10             	add    $0x10,%esp
  85:	c9                   	leave  
  86:	c3                   	ret    

00000087 <main>:


int
main(int argc, char *argv[])
{
  87:	f3 0f 1e fb          	endbr32 
  8b:	8d 4c 24 04          	lea    0x4(%esp),%ecx
  8f:	83 e4 f0             	and    $0xfffffff0,%esp
  92:	ff 71 fc             	pushl  -0x4(%ecx)
  95:	55                   	push   %ebp
  96:	89 e5                	mov    %esp,%ebp
  98:	51                   	push   %ecx
  99:	83 ec 0c             	sub    $0xc,%esp
  printf (1, "Este programa primero intenta acceder mas alla de sz.\n");
  9c:	68 b4 03 00 00       	push   $0x3b4
  a1:	6a 01                	push   $0x1
  a3:	e8 62 01 00 00       	call   20a <printf>

  // Más allá de sz
  test1();
  a8:	e8 53 ff ff ff       	call   0 <test1>

  // Guarda
  test2();
  ad:	e8 7d ff ff ff       	call   2f <test2>

  // Núcleo
  test3();
  b2:	e8 ae ff ff ff       	call   65 <test3>

  exit (0);
  b7:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  be:	e8 08 00 00 00       	call   cb <exit>

000000c3 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
  c3:	b8 01 00 00 00       	mov    $0x1,%eax
  c8:	cd 40                	int    $0x40
  ca:	c3                   	ret    

000000cb <exit>:
SYSCALL(exit)
  cb:	b8 02 00 00 00       	mov    $0x2,%eax
  d0:	cd 40                	int    $0x40
  d2:	c3                   	ret    

000000d3 <wait>:
SYSCALL(wait)
  d3:	b8 03 00 00 00       	mov    $0x3,%eax
  d8:	cd 40                	int    $0x40
  da:	c3                   	ret    

000000db <pipe>:
SYSCALL(pipe)
  db:	b8 04 00 00 00       	mov    $0x4,%eax
  e0:	cd 40                	int    $0x40
  e2:	c3                   	ret    

000000e3 <read>:
SYSCALL(read)
  e3:	b8 05 00 00 00       	mov    $0x5,%eax
  e8:	cd 40                	int    $0x40
  ea:	c3                   	ret    

000000eb <write>:
SYSCALL(write)
  eb:	b8 10 00 00 00       	mov    $0x10,%eax
  f0:	cd 40                	int    $0x40
  f2:	c3                   	ret    

000000f3 <close>:
SYSCALL(close)
  f3:	b8 15 00 00 00       	mov    $0x15,%eax
  f8:	cd 40                	int    $0x40
  fa:	c3                   	ret    

000000fb <kill>:
SYSCALL(kill)
  fb:	b8 06 00 00 00       	mov    $0x6,%eax
 100:	cd 40                	int    $0x40
 102:	c3                   	ret    

00000103 <exec>:
SYSCALL(exec)
 103:	b8 07 00 00 00       	mov    $0x7,%eax
 108:	cd 40                	int    $0x40
 10a:	c3                   	ret    

0000010b <open>:
SYSCALL(open)
 10b:	b8 0f 00 00 00       	mov    $0xf,%eax
 110:	cd 40                	int    $0x40
 112:	c3                   	ret    

00000113 <mknod>:
SYSCALL(mknod)
 113:	b8 11 00 00 00       	mov    $0x11,%eax
 118:	cd 40                	int    $0x40
 11a:	c3                   	ret    

0000011b <unlink>:
SYSCALL(unlink)
 11b:	b8 12 00 00 00       	mov    $0x12,%eax
 120:	cd 40                	int    $0x40
 122:	c3                   	ret    

00000123 <fstat>:
SYSCALL(fstat)
 123:	b8 08 00 00 00       	mov    $0x8,%eax
 128:	cd 40                	int    $0x40
 12a:	c3                   	ret    

0000012b <link>:
SYSCALL(link)
 12b:	b8 13 00 00 00       	mov    $0x13,%eax
 130:	cd 40                	int    $0x40
 132:	c3                   	ret    

00000133 <mkdir>:
SYSCALL(mkdir)
 133:	b8 14 00 00 00       	mov    $0x14,%eax
 138:	cd 40                	int    $0x40
 13a:	c3                   	ret    

0000013b <chdir>:
SYSCALL(chdir)
 13b:	b8 09 00 00 00       	mov    $0x9,%eax
 140:	cd 40                	int    $0x40
 142:	c3                   	ret    

00000143 <dup>:
SYSCALL(dup)
 143:	b8 0a 00 00 00       	mov    $0xa,%eax
 148:	cd 40                	int    $0x40
 14a:	c3                   	ret    

0000014b <getpid>:
SYSCALL(getpid)
 14b:	b8 0b 00 00 00       	mov    $0xb,%eax
 150:	cd 40                	int    $0x40
 152:	c3                   	ret    

00000153 <sbrk>:
SYSCALL(sbrk)
 153:	b8 0c 00 00 00       	mov    $0xc,%eax
 158:	cd 40                	int    $0x40
 15a:	c3                   	ret    

0000015b <sleep>:
SYSCALL(sleep)
 15b:	b8 0d 00 00 00       	mov    $0xd,%eax
 160:	cd 40                	int    $0x40
 162:	c3                   	ret    

00000163 <uptime>:
SYSCALL(uptime)
 163:	b8 0e 00 00 00       	mov    $0xe,%eax
 168:	cd 40                	int    $0x40
 16a:	c3                   	ret    

0000016b <date>:
SYSCALL(date)
 16b:	b8 16 00 00 00       	mov    $0x16,%eax
 170:	cd 40                	int    $0x40
 172:	c3                   	ret    

00000173 <dup2>:
 173:	b8 17 00 00 00       	mov    $0x17,%eax
 178:	cd 40                	int    $0x40
 17a:	c3                   	ret    

0000017b <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 17b:	55                   	push   %ebp
 17c:	89 e5                	mov    %esp,%ebp
 17e:	83 ec 1c             	sub    $0x1c,%esp
 181:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 184:	6a 01                	push   $0x1
 186:	8d 55 f4             	lea    -0xc(%ebp),%edx
 189:	52                   	push   %edx
 18a:	50                   	push   %eax
 18b:	e8 5b ff ff ff       	call   eb <write>
}
 190:	83 c4 10             	add    $0x10,%esp
 193:	c9                   	leave  
 194:	c3                   	ret    

00000195 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 195:	55                   	push   %ebp
 196:	89 e5                	mov    %esp,%ebp
 198:	57                   	push   %edi
 199:	56                   	push   %esi
 19a:	53                   	push   %ebx
 19b:	83 ec 2c             	sub    $0x2c,%esp
 19e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 1a1:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 1a3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 1a7:	74 04                	je     1ad <printint+0x18>
 1a9:	85 d2                	test   %edx,%edx
 1ab:	78 3a                	js     1e7 <printint+0x52>
  neg = 0;
 1ad:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 1b4:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 1b9:	89 f0                	mov    %esi,%eax
 1bb:	ba 00 00 00 00       	mov    $0x0,%edx
 1c0:	f7 f1                	div    %ecx
 1c2:	89 df                	mov    %ebx,%edi
 1c4:	43                   	inc    %ebx
 1c5:	8a 92 f4 03 00 00    	mov    0x3f4(%edx),%dl
 1cb:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 1cf:	89 f2                	mov    %esi,%edx
 1d1:	89 c6                	mov    %eax,%esi
 1d3:	39 d1                	cmp    %edx,%ecx
 1d5:	76 e2                	jbe    1b9 <printint+0x24>
  if(neg)
 1d7:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 1db:	74 22                	je     1ff <printint+0x6a>
    buf[i++] = '-';
 1dd:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 1e2:	8d 5f 02             	lea    0x2(%edi),%ebx
 1e5:	eb 18                	jmp    1ff <printint+0x6a>
    x = -xx;
 1e7:	f7 de                	neg    %esi
    neg = 1;
 1e9:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 1f0:	eb c2                	jmp    1b4 <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 1f2:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 1f7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 1fa:	e8 7c ff ff ff       	call   17b <putc>
  while(--i >= 0)
 1ff:	4b                   	dec    %ebx
 200:	79 f0                	jns    1f2 <printint+0x5d>
}
 202:	83 c4 2c             	add    $0x2c,%esp
 205:	5b                   	pop    %ebx
 206:	5e                   	pop    %esi
 207:	5f                   	pop    %edi
 208:	5d                   	pop    %ebp
 209:	c3                   	ret    

0000020a <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 20a:	f3 0f 1e fb          	endbr32 
 20e:	55                   	push   %ebp
 20f:	89 e5                	mov    %esp,%ebp
 211:	57                   	push   %edi
 212:	56                   	push   %esi
 213:	53                   	push   %ebx
 214:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 217:	8d 45 10             	lea    0x10(%ebp),%eax
 21a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 21d:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 222:	bb 00 00 00 00       	mov    $0x0,%ebx
 227:	eb 12                	jmp    23b <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 229:	89 fa                	mov    %edi,%edx
 22b:	8b 45 08             	mov    0x8(%ebp),%eax
 22e:	e8 48 ff ff ff       	call   17b <putc>
 233:	eb 05                	jmp    23a <printf+0x30>
      }
    } else if(state == '%'){
 235:	83 fe 25             	cmp    $0x25,%esi
 238:	74 22                	je     25c <printf+0x52>
  for(i = 0; fmt[i]; i++){
 23a:	43                   	inc    %ebx
 23b:	8b 45 0c             	mov    0xc(%ebp),%eax
 23e:	8a 04 18             	mov    (%eax,%ebx,1),%al
 241:	84 c0                	test   %al,%al
 243:	0f 84 13 01 00 00    	je     35c <printf+0x152>
    c = fmt[i] & 0xff;
 249:	0f be f8             	movsbl %al,%edi
 24c:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 24f:	85 f6                	test   %esi,%esi
 251:	75 e2                	jne    235 <printf+0x2b>
      if(c == '%'){
 253:	83 f8 25             	cmp    $0x25,%eax
 256:	75 d1                	jne    229 <printf+0x1f>
        state = '%';
 258:	89 c6                	mov    %eax,%esi
 25a:	eb de                	jmp    23a <printf+0x30>
      if(c == 'd'){
 25c:	83 f8 64             	cmp    $0x64,%eax
 25f:	74 43                	je     2a4 <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 261:	83 f8 78             	cmp    $0x78,%eax
 264:	74 68                	je     2ce <printf+0xc4>
 266:	83 f8 70             	cmp    $0x70,%eax
 269:	74 63                	je     2ce <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 26b:	83 f8 73             	cmp    $0x73,%eax
 26e:	0f 84 84 00 00 00    	je     2f8 <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 274:	83 f8 63             	cmp    $0x63,%eax
 277:	0f 84 ad 00 00 00    	je     32a <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 27d:	83 f8 25             	cmp    $0x25,%eax
 280:	0f 84 c2 00 00 00    	je     348 <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 286:	ba 25 00 00 00       	mov    $0x25,%edx
 28b:	8b 45 08             	mov    0x8(%ebp),%eax
 28e:	e8 e8 fe ff ff       	call   17b <putc>
        putc(fd, c);
 293:	89 fa                	mov    %edi,%edx
 295:	8b 45 08             	mov    0x8(%ebp),%eax
 298:	e8 de fe ff ff       	call   17b <putc>
      }
      state = 0;
 29d:	be 00 00 00 00       	mov    $0x0,%esi
 2a2:	eb 96                	jmp    23a <printf+0x30>
        printint(fd, *ap, 10, 1);
 2a4:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2a7:	8b 17                	mov    (%edi),%edx
 2a9:	83 ec 0c             	sub    $0xc,%esp
 2ac:	6a 01                	push   $0x1
 2ae:	b9 0a 00 00 00       	mov    $0xa,%ecx
 2b3:	8b 45 08             	mov    0x8(%ebp),%eax
 2b6:	e8 da fe ff ff       	call   195 <printint>
        ap++;
 2bb:	83 c7 04             	add    $0x4,%edi
 2be:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2c1:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2c4:	be 00 00 00 00       	mov    $0x0,%esi
 2c9:	e9 6c ff ff ff       	jmp    23a <printf+0x30>
        printint(fd, *ap, 16, 0);
 2ce:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 2d1:	8b 17                	mov    (%edi),%edx
 2d3:	83 ec 0c             	sub    $0xc,%esp
 2d6:	6a 00                	push   $0x0
 2d8:	b9 10 00 00 00       	mov    $0x10,%ecx
 2dd:	8b 45 08             	mov    0x8(%ebp),%eax
 2e0:	e8 b0 fe ff ff       	call   195 <printint>
        ap++;
 2e5:	83 c7 04             	add    $0x4,%edi
 2e8:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 2eb:	83 c4 10             	add    $0x10,%esp
      state = 0;
 2ee:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 2f3:	e9 42 ff ff ff       	jmp    23a <printf+0x30>
        s = (char*)*ap;
 2f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 2fb:	8b 30                	mov    (%eax),%esi
        ap++;
 2fd:	83 c0 04             	add    $0x4,%eax
 300:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 303:	85 f6                	test   %esi,%esi
 305:	75 13                	jne    31a <printf+0x110>
          s = "(null)";
 307:	be eb 03 00 00       	mov    $0x3eb,%esi
 30c:	eb 0c                	jmp    31a <printf+0x110>
          putc(fd, *s);
 30e:	0f be d2             	movsbl %dl,%edx
 311:	8b 45 08             	mov    0x8(%ebp),%eax
 314:	e8 62 fe ff ff       	call   17b <putc>
          s++;
 319:	46                   	inc    %esi
        while(*s != 0){
 31a:	8a 16                	mov    (%esi),%dl
 31c:	84 d2                	test   %dl,%dl
 31e:	75 ee                	jne    30e <printf+0x104>
      state = 0;
 320:	be 00 00 00 00       	mov    $0x0,%esi
 325:	e9 10 ff ff ff       	jmp    23a <printf+0x30>
        putc(fd, *ap);
 32a:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 32d:	0f be 17             	movsbl (%edi),%edx
 330:	8b 45 08             	mov    0x8(%ebp),%eax
 333:	e8 43 fe ff ff       	call   17b <putc>
        ap++;
 338:	83 c7 04             	add    $0x4,%edi
 33b:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 33e:	be 00 00 00 00       	mov    $0x0,%esi
 343:	e9 f2 fe ff ff       	jmp    23a <printf+0x30>
        putc(fd, c);
 348:	89 fa                	mov    %edi,%edx
 34a:	8b 45 08             	mov    0x8(%ebp),%eax
 34d:	e8 29 fe ff ff       	call   17b <putc>
      state = 0;
 352:	be 00 00 00 00       	mov    $0x0,%esi
 357:	e9 de fe ff ff       	jmp    23a <printf+0x30>
    }
  }
}
 35c:	8d 65 f4             	lea    -0xc(%ebp),%esp
 35f:	5b                   	pop    %ebx
 360:	5e                   	pop    %esi
 361:	5f                   	pop    %edi
 362:	5d                   	pop    %ebp
 363:	c3                   	ret    
