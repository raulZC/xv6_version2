
sh:     formato del fichero elf32-i386


Desensamblado de la sección .text:

00000000 <getcmd>:
  exit();
}

int
getcmd(char *buf, int nbuf)
{
   0:	f3 0f 1e fb          	endbr32 
   4:	55                   	push   %ebp
   5:	89 e5                	mov    %esp,%ebp
   7:	56                   	push   %esi
   8:	53                   	push   %ebx
   9:	8b 5d 08             	mov    0x8(%ebp),%ebx
   c:	8b 75 0c             	mov    0xc(%ebp),%esi
  printf(2, "$ ");
   f:	83 ec 08             	sub    $0x8,%esp
  12:	68 68 0f 00 00       	push   $0xf68
  17:	6a 02                	push   $0x2
  19:	e8 a0 0c 00 00       	call   cbe <printf>
  memset(buf, 0, nbuf);
  1e:	83 c4 0c             	add    $0xc,%esp
  21:	56                   	push   %esi
  22:	6a 00                	push   $0x0
  24:	53                   	push   %ebx
  25:	e8 18 0a 00 00       	call   a42 <memset>
  gets(buf, nbuf);
  2a:	83 c4 08             	add    $0x8,%esp
  2d:	56                   	push   %esi
  2e:	53                   	push   %ebx
  2f:	e8 49 0a 00 00       	call   a7d <gets>
  if(buf[0] == 0) // EOF
  34:	83 c4 10             	add    $0x10,%esp
  37:	80 3b 00             	cmpb   $0x0,(%ebx)
  3a:	74 0c                	je     48 <getcmd+0x48>
    return -1;
  return 0;
  3c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  41:	8d 65 f8             	lea    -0x8(%ebp),%esp
  44:	5b                   	pop    %ebx
  45:	5e                   	pop    %esi
  46:	5d                   	pop    %ebp
  47:	c3                   	ret    
    return -1;
  48:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  4d:	eb f2                	jmp    41 <getcmd+0x41>

0000004f <panic>:
  exit();
}

void
panic(char *s)
{
  4f:	f3 0f 1e fb          	endbr32 
  53:	55                   	push   %ebp
  54:	89 e5                	mov    %esp,%ebp
  56:	83 ec 0c             	sub    $0xc,%esp
  printf(2, "%s\n", s);
  59:	ff 75 08             	pushl  0x8(%ebp)
  5c:	68 05 10 00 00       	push   $0x1005
  61:	6a 02                	push   $0x2
  63:	e8 56 0c 00 00       	call   cbe <printf>
  exit();
  68:	e8 12 0b 00 00       	call   b7f <exit>

0000006d <fork1>:
}

int
fork1(void)
{
  6d:	f3 0f 1e fb          	endbr32 
  71:	55                   	push   %ebp
  72:	89 e5                	mov    %esp,%ebp
  74:	83 ec 08             	sub    $0x8,%esp
  int pid;

  pid = fork();
  77:	e8 fb 0a 00 00       	call   b77 <fork>
  if(pid == -1)
  7c:	83 f8 ff             	cmp    $0xffffffff,%eax
  7f:	74 02                	je     83 <fork1+0x16>
    panic("fork");
  return pid;
}
  81:	c9                   	leave  
  82:	c3                   	ret    
    panic("fork");
  83:	83 ec 0c             	sub    $0xc,%esp
  86:	68 6b 0f 00 00       	push   $0xf6b
  8b:	e8 bf ff ff ff       	call   4f <panic>

00000090 <runcmd>:
{
  90:	f3 0f 1e fb          	endbr32 
  94:	55                   	push   %ebp
  95:	89 e5                	mov    %esp,%ebp
  97:	53                   	push   %ebx
  98:	83 ec 14             	sub    $0x14,%esp
  9b:	8b 5d 08             	mov    0x8(%ebp),%ebx
  if(cmd == 0)
  9e:	85 db                	test   %ebx,%ebx
  a0:	74 0f                	je     b1 <runcmd+0x21>
  switch(cmd->type){
  a2:	8b 03                	mov    (%ebx),%eax
  a4:	83 f8 05             	cmp    $0x5,%eax
  a7:	77 0d                	ja     b6 <runcmd+0x26>
  a9:	3e ff 24 85 20 10 00 	notrack jmp *0x1020(,%eax,4)
  b0:	00 
    exit();
  b1:	e8 c9 0a 00 00       	call   b7f <exit>
    panic("runcmd");
  b6:	83 ec 0c             	sub    $0xc,%esp
  b9:	68 70 0f 00 00       	push   $0xf70
  be:	e8 8c ff ff ff       	call   4f <panic>
    if(ecmd->argv[0] == 0)
  c3:	8b 43 04             	mov    0x4(%ebx),%eax
  c6:	85 c0                	test   %eax,%eax
  c8:	74 27                	je     f1 <runcmd+0x61>
    exec(ecmd->argv[0], ecmd->argv);
  ca:	8d 53 04             	lea    0x4(%ebx),%edx
  cd:	83 ec 08             	sub    $0x8,%esp
  d0:	52                   	push   %edx
  d1:	50                   	push   %eax
  d2:	e8 e0 0a 00 00       	call   bb7 <exec>
    printf(2, "exec %s failed\n", ecmd->argv[0]);
  d7:	83 c4 0c             	add    $0xc,%esp
  da:	ff 73 04             	pushl  0x4(%ebx)
  dd:	68 77 0f 00 00       	push   $0xf77
  e2:	6a 02                	push   $0x2
  e4:	e8 d5 0b 00 00       	call   cbe <printf>
    break;
  e9:	83 c4 10             	add    $0x10,%esp
  exit();
  ec:	e8 8e 0a 00 00       	call   b7f <exit>
      exit();
  f1:	e8 89 0a 00 00       	call   b7f <exit>
    close(rcmd->fd);
  f6:	83 ec 0c             	sub    $0xc,%esp
  f9:	ff 73 14             	pushl  0x14(%ebx)
  fc:	e8 a6 0a 00 00       	call   ba7 <close>
    if(open(rcmd->file, rcmd->mode) < 0){
 101:	83 c4 08             	add    $0x8,%esp
 104:	ff 73 10             	pushl  0x10(%ebx)
 107:	ff 73 08             	pushl  0x8(%ebx)
 10a:	e8 b0 0a 00 00       	call   bbf <open>
 10f:	83 c4 10             	add    $0x10,%esp
 112:	85 c0                	test   %eax,%eax
 114:	78 0b                	js     121 <runcmd+0x91>
    runcmd(rcmd->cmd);
 116:	83 ec 0c             	sub    $0xc,%esp
 119:	ff 73 04             	pushl  0x4(%ebx)
 11c:	e8 6f ff ff ff       	call   90 <runcmd>
      printf(2, "open %s failed\n", rcmd->file);
 121:	83 ec 04             	sub    $0x4,%esp
 124:	ff 73 08             	pushl  0x8(%ebx)
 127:	68 87 0f 00 00       	push   $0xf87
 12c:	6a 02                	push   $0x2
 12e:	e8 8b 0b 00 00       	call   cbe <printf>
      exit();
 133:	e8 47 0a 00 00       	call   b7f <exit>
    if(fork1() == 0)
 138:	e8 30 ff ff ff       	call   6d <fork1>
 13d:	85 c0                	test   %eax,%eax
 13f:	74 10                	je     151 <runcmd+0xc1>
    wait();
 141:	e8 41 0a 00 00       	call   b87 <wait>
    runcmd(lcmd->right);
 146:	83 ec 0c             	sub    $0xc,%esp
 149:	ff 73 08             	pushl  0x8(%ebx)
 14c:	e8 3f ff ff ff       	call   90 <runcmd>
      runcmd(lcmd->left);
 151:	83 ec 0c             	sub    $0xc,%esp
 154:	ff 73 04             	pushl  0x4(%ebx)
 157:	e8 34 ff ff ff       	call   90 <runcmd>
    if(pipe(p) < 0)
 15c:	83 ec 0c             	sub    $0xc,%esp
 15f:	8d 45 f0             	lea    -0x10(%ebp),%eax
 162:	50                   	push   %eax
 163:	e8 27 0a 00 00       	call   b8f <pipe>
 168:	83 c4 10             	add    $0x10,%esp
 16b:	85 c0                	test   %eax,%eax
 16d:	78 3a                	js     1a9 <runcmd+0x119>
    if(fork1() == 0){
 16f:	e8 f9 fe ff ff       	call   6d <fork1>
 174:	85 c0                	test   %eax,%eax
 176:	74 3e                	je     1b6 <runcmd+0x126>
    if(fork1() == 0){
 178:	e8 f0 fe ff ff       	call   6d <fork1>
 17d:	85 c0                	test   %eax,%eax
 17f:	74 63                	je     1e4 <runcmd+0x154>
    close(p[0]);
 181:	83 ec 0c             	sub    $0xc,%esp
 184:	ff 75 f0             	pushl  -0x10(%ebp)
 187:	e8 1b 0a 00 00       	call   ba7 <close>
    close(p[1]);
 18c:	83 c4 04             	add    $0x4,%esp
 18f:	ff 75 f4             	pushl  -0xc(%ebp)
 192:	e8 10 0a 00 00       	call   ba7 <close>
    wait();
 197:	e8 eb 09 00 00       	call   b87 <wait>
    wait();
 19c:	e8 e6 09 00 00       	call   b87 <wait>
    break;
 1a1:	83 c4 10             	add    $0x10,%esp
 1a4:	e9 43 ff ff ff       	jmp    ec <runcmd+0x5c>
      panic("pipe");
 1a9:	83 ec 0c             	sub    $0xc,%esp
 1ac:	68 97 0f 00 00       	push   $0xf97
 1b1:	e8 99 fe ff ff       	call   4f <panic>
      dup2(p[1],1);
 1b6:	83 ec 08             	sub    $0x8,%esp
 1b9:	6a 01                	push   $0x1
 1bb:	ff 75 f4             	pushl  -0xc(%ebp)
 1be:	e8 64 0a 00 00       	call   c27 <dup2>
      close(p[0]);
 1c3:	83 c4 04             	add    $0x4,%esp
 1c6:	ff 75 f0             	pushl  -0x10(%ebp)
 1c9:	e8 d9 09 00 00       	call   ba7 <close>
      close(p[1]);
 1ce:	83 c4 04             	add    $0x4,%esp
 1d1:	ff 75 f4             	pushl  -0xc(%ebp)
 1d4:	e8 ce 09 00 00       	call   ba7 <close>
      runcmd(pcmd->left);
 1d9:	83 c4 04             	add    $0x4,%esp
 1dc:	ff 73 04             	pushl  0x4(%ebx)
 1df:	e8 ac fe ff ff       	call   90 <runcmd>
      dup2(p[0],0);
 1e4:	83 ec 08             	sub    $0x8,%esp
 1e7:	6a 00                	push   $0x0
 1e9:	ff 75 f0             	pushl  -0x10(%ebp)
 1ec:	e8 36 0a 00 00       	call   c27 <dup2>
      close(p[0]);
 1f1:	83 c4 04             	add    $0x4,%esp
 1f4:	ff 75 f0             	pushl  -0x10(%ebp)
 1f7:	e8 ab 09 00 00       	call   ba7 <close>
      close(p[1]);
 1fc:	83 c4 04             	add    $0x4,%esp
 1ff:	ff 75 f4             	pushl  -0xc(%ebp)
 202:	e8 a0 09 00 00       	call   ba7 <close>
      runcmd(pcmd->right);
 207:	83 c4 04             	add    $0x4,%esp
 20a:	ff 73 08             	pushl  0x8(%ebx)
 20d:	e8 7e fe ff ff       	call   90 <runcmd>
    if(fork1() == 0)
 212:	e8 56 fe ff ff       	call   6d <fork1>
 217:	85 c0                	test   %eax,%eax
 219:	0f 85 cd fe ff ff    	jne    ec <runcmd+0x5c>
      runcmd(bcmd->cmd);
 21f:	83 ec 0c             	sub    $0xc,%esp
 222:	ff 73 04             	pushl  0x4(%ebx)
 225:	e8 66 fe ff ff       	call   90 <runcmd>

0000022a <execcmd>:
//PAGEBREAK!
// Constructors

struct cmd*
execcmd(void)
{
 22a:	f3 0f 1e fb          	endbr32 
 22e:	55                   	push   %ebp
 22f:	89 e5                	mov    %esp,%ebp
 231:	53                   	push   %ebx
 232:	83 ec 10             	sub    $0x10,%esp
  struct execcmd *cmd;

  cmd = malloc(sizeof(*cmd));
 235:	6a 54                	push   $0x54
 237:	e8 a0 0c 00 00       	call   edc <malloc>
 23c:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
 23e:	83 c4 0c             	add    $0xc,%esp
 241:	6a 54                	push   $0x54
 243:	6a 00                	push   $0x0
 245:	50                   	push   %eax
 246:	e8 f7 07 00 00       	call   a42 <memset>
  cmd->type = EXEC;
 24b:	c7 03 01 00 00 00    	movl   $0x1,(%ebx)
  return (struct cmd*)cmd;
}
 251:	89 d8                	mov    %ebx,%eax
 253:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 256:	c9                   	leave  
 257:	c3                   	ret    

00000258 <redircmd>:

struct cmd*
redircmd(struct cmd *subcmd, char *file, char *efile, int mode, int fd)
{
 258:	f3 0f 1e fb          	endbr32 
 25c:	55                   	push   %ebp
 25d:	89 e5                	mov    %esp,%ebp
 25f:	53                   	push   %ebx
 260:	83 ec 10             	sub    $0x10,%esp
  struct redircmd *cmd;

  cmd = malloc(sizeof(*cmd));
 263:	6a 18                	push   $0x18
 265:	e8 72 0c 00 00       	call   edc <malloc>
 26a:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
 26c:	83 c4 0c             	add    $0xc,%esp
 26f:	6a 18                	push   $0x18
 271:	6a 00                	push   $0x0
 273:	50                   	push   %eax
 274:	e8 c9 07 00 00       	call   a42 <memset>
  cmd->type = REDIR;
 279:	c7 03 02 00 00 00    	movl   $0x2,(%ebx)
  cmd->cmd = subcmd;
 27f:	8b 45 08             	mov    0x8(%ebp),%eax
 282:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->file = file;
 285:	8b 45 0c             	mov    0xc(%ebp),%eax
 288:	89 43 08             	mov    %eax,0x8(%ebx)
  cmd->efile = efile;
 28b:	8b 45 10             	mov    0x10(%ebp),%eax
 28e:	89 43 0c             	mov    %eax,0xc(%ebx)
  cmd->mode = mode;
 291:	8b 45 14             	mov    0x14(%ebp),%eax
 294:	89 43 10             	mov    %eax,0x10(%ebx)
  cmd->fd = fd;
 297:	8b 45 18             	mov    0x18(%ebp),%eax
 29a:	89 43 14             	mov    %eax,0x14(%ebx)
  return (struct cmd*)cmd;
}
 29d:	89 d8                	mov    %ebx,%eax
 29f:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2a2:	c9                   	leave  
 2a3:	c3                   	ret    

000002a4 <pipecmd>:

struct cmd*
pipecmd(struct cmd *left, struct cmd *right)
{
 2a4:	f3 0f 1e fb          	endbr32 
 2a8:	55                   	push   %ebp
 2a9:	89 e5                	mov    %esp,%ebp
 2ab:	53                   	push   %ebx
 2ac:	83 ec 10             	sub    $0x10,%esp
  struct pipecmd *cmd;

  cmd = malloc(sizeof(*cmd));
 2af:	6a 0c                	push   $0xc
 2b1:	e8 26 0c 00 00       	call   edc <malloc>
 2b6:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
 2b8:	83 c4 0c             	add    $0xc,%esp
 2bb:	6a 0c                	push   $0xc
 2bd:	6a 00                	push   $0x0
 2bf:	50                   	push   %eax
 2c0:	e8 7d 07 00 00       	call   a42 <memset>
  cmd->type = PIPE;
 2c5:	c7 03 03 00 00 00    	movl   $0x3,(%ebx)
  cmd->left = left;
 2cb:	8b 45 08             	mov    0x8(%ebp),%eax
 2ce:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
 2d1:	8b 45 0c             	mov    0xc(%ebp),%eax
 2d4:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
 2d7:	89 d8                	mov    %ebx,%eax
 2d9:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 2dc:	c9                   	leave  
 2dd:	c3                   	ret    

000002de <listcmd>:

struct cmd*
listcmd(struct cmd *left, struct cmd *right)
{
 2de:	f3 0f 1e fb          	endbr32 
 2e2:	55                   	push   %ebp
 2e3:	89 e5                	mov    %esp,%ebp
 2e5:	53                   	push   %ebx
 2e6:	83 ec 10             	sub    $0x10,%esp
  struct listcmd *cmd;

  cmd = malloc(sizeof(*cmd));
 2e9:	6a 0c                	push   $0xc
 2eb:	e8 ec 0b 00 00       	call   edc <malloc>
 2f0:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
 2f2:	83 c4 0c             	add    $0xc,%esp
 2f5:	6a 0c                	push   $0xc
 2f7:	6a 00                	push   $0x0
 2f9:	50                   	push   %eax
 2fa:	e8 43 07 00 00       	call   a42 <memset>
  cmd->type = LIST;
 2ff:	c7 03 04 00 00 00    	movl   $0x4,(%ebx)
  cmd->left = left;
 305:	8b 45 08             	mov    0x8(%ebp),%eax
 308:	89 43 04             	mov    %eax,0x4(%ebx)
  cmd->right = right;
 30b:	8b 45 0c             	mov    0xc(%ebp),%eax
 30e:	89 43 08             	mov    %eax,0x8(%ebx)
  return (struct cmd*)cmd;
}
 311:	89 d8                	mov    %ebx,%eax
 313:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 316:	c9                   	leave  
 317:	c3                   	ret    

00000318 <backcmd>:

struct cmd*
backcmd(struct cmd *subcmd)
{
 318:	f3 0f 1e fb          	endbr32 
 31c:	55                   	push   %ebp
 31d:	89 e5                	mov    %esp,%ebp
 31f:	53                   	push   %ebx
 320:	83 ec 10             	sub    $0x10,%esp
  struct backcmd *cmd;

  cmd = malloc(sizeof(*cmd));
 323:	6a 08                	push   $0x8
 325:	e8 b2 0b 00 00       	call   edc <malloc>
 32a:	89 c3                	mov    %eax,%ebx
  memset(cmd, 0, sizeof(*cmd));
 32c:	83 c4 0c             	add    $0xc,%esp
 32f:	6a 08                	push   $0x8
 331:	6a 00                	push   $0x0
 333:	50                   	push   %eax
 334:	e8 09 07 00 00       	call   a42 <memset>
  cmd->type = BACK;
 339:	c7 03 05 00 00 00    	movl   $0x5,(%ebx)
  cmd->cmd = subcmd;
 33f:	8b 45 08             	mov    0x8(%ebp),%eax
 342:	89 43 04             	mov    %eax,0x4(%ebx)
  return (struct cmd*)cmd;
}
 345:	89 d8                	mov    %ebx,%eax
 347:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 34a:	c9                   	leave  
 34b:	c3                   	ret    

0000034c <gettoken>:
char whitespace[] = " \t\r\n\v";
char symbols[] = "<|>&;()";

int
gettoken(char **ps, char *es, char **q, char **eq)
{
 34c:	f3 0f 1e fb          	endbr32 
 350:	55                   	push   %ebp
 351:	89 e5                	mov    %esp,%ebp
 353:	57                   	push   %edi
 354:	56                   	push   %esi
 355:	53                   	push   %ebx
 356:	83 ec 0c             	sub    $0xc,%esp
 359:	8b 75 0c             	mov    0xc(%ebp),%esi
 35c:	8b 7d 10             	mov    0x10(%ebp),%edi
  char *s;
  int ret;

  s = *ps;
 35f:	8b 45 08             	mov    0x8(%ebp),%eax
 362:	8b 18                	mov    (%eax),%ebx
  while(s < es && strchr(whitespace, *s))
 364:	39 f3                	cmp    %esi,%ebx
 366:	73 1b                	jae    383 <gettoken+0x37>
 368:	83 ec 08             	sub    $0x8,%esp
 36b:	0f be 03             	movsbl (%ebx),%eax
 36e:	50                   	push   %eax
 36f:	68 e8 15 00 00       	push   $0x15e8
 374:	e8 e3 06 00 00       	call   a5c <strchr>
 379:	83 c4 10             	add    $0x10,%esp
 37c:	85 c0                	test   %eax,%eax
 37e:	74 03                	je     383 <gettoken+0x37>
    s++;
 380:	43                   	inc    %ebx
 381:	eb e1                	jmp    364 <gettoken+0x18>
  if(q)
 383:	85 ff                	test   %edi,%edi
 385:	74 02                	je     389 <gettoken+0x3d>
    *q = s;
 387:	89 1f                	mov    %ebx,(%edi)
  ret = *s;
 389:	8a 03                	mov    (%ebx),%al
 38b:	0f be f8             	movsbl %al,%edi
  switch(*s){
 38e:	3c 3c                	cmp    $0x3c,%al
 390:	7f 25                	jg     3b7 <gettoken+0x6b>
 392:	3c 3b                	cmp    $0x3b,%al
 394:	7d 13                	jge    3a9 <gettoken+0x5d>
 396:	84 c0                	test   %al,%al
 398:	74 10                	je     3aa <gettoken+0x5e>
 39a:	78 3d                	js     3d9 <gettoken+0x8d>
 39c:	3c 26                	cmp    $0x26,%al
 39e:	74 09                	je     3a9 <gettoken+0x5d>
 3a0:	7c 37                	jl     3d9 <gettoken+0x8d>
 3a2:	83 e8 28             	sub    $0x28,%eax
 3a5:	3c 01                	cmp    $0x1,%al
 3a7:	77 30                	ja     3d9 <gettoken+0x8d>
  case '(':
  case ')':
  case ';':
  case '&':
  case '<':
    s++;
 3a9:	43                   	inc    %ebx
    ret = 'a';
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
      s++;
    break;
  }
  if(eq)
 3aa:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
 3ae:	74 73                	je     423 <gettoken+0xd7>
    *eq = s;
 3b0:	8b 45 14             	mov    0x14(%ebp),%eax
 3b3:	89 18                	mov    %ebx,(%eax)
 3b5:	eb 6c                	jmp    423 <gettoken+0xd7>
  switch(*s){
 3b7:	3c 3e                	cmp    $0x3e,%al
 3b9:	75 0d                	jne    3c8 <gettoken+0x7c>
    s++;
 3bb:	8d 43 01             	lea    0x1(%ebx),%eax
    if(*s == '>'){
 3be:	80 7b 01 3e          	cmpb   $0x3e,0x1(%ebx)
 3c2:	74 0a                	je     3ce <gettoken+0x82>
    s++;
 3c4:	89 c3                	mov    %eax,%ebx
 3c6:	eb e2                	jmp    3aa <gettoken+0x5e>
  switch(*s){
 3c8:	3c 7c                	cmp    $0x7c,%al
 3ca:	75 0d                	jne    3d9 <gettoken+0x8d>
 3cc:	eb db                	jmp    3a9 <gettoken+0x5d>
      s++;
 3ce:	83 c3 02             	add    $0x2,%ebx
      ret = '+';
 3d1:	bf 2b 00 00 00       	mov    $0x2b,%edi
 3d6:	eb d2                	jmp    3aa <gettoken+0x5e>
      s++;
 3d8:	43                   	inc    %ebx
    while(s < es && !strchr(whitespace, *s) && !strchr(symbols, *s))
 3d9:	39 f3                	cmp    %esi,%ebx
 3db:	73 37                	jae    414 <gettoken+0xc8>
 3dd:	83 ec 08             	sub    $0x8,%esp
 3e0:	0f be 03             	movsbl (%ebx),%eax
 3e3:	50                   	push   %eax
 3e4:	68 e8 15 00 00       	push   $0x15e8
 3e9:	e8 6e 06 00 00       	call   a5c <strchr>
 3ee:	83 c4 10             	add    $0x10,%esp
 3f1:	85 c0                	test   %eax,%eax
 3f3:	75 26                	jne    41b <gettoken+0xcf>
 3f5:	83 ec 08             	sub    $0x8,%esp
 3f8:	0f be 03             	movsbl (%ebx),%eax
 3fb:	50                   	push   %eax
 3fc:	68 e0 15 00 00       	push   $0x15e0
 401:	e8 56 06 00 00       	call   a5c <strchr>
 406:	83 c4 10             	add    $0x10,%esp
 409:	85 c0                	test   %eax,%eax
 40b:	74 cb                	je     3d8 <gettoken+0x8c>
    ret = 'a';
 40d:	bf 61 00 00 00       	mov    $0x61,%edi
 412:	eb 96                	jmp    3aa <gettoken+0x5e>
 414:	bf 61 00 00 00       	mov    $0x61,%edi
 419:	eb 8f                	jmp    3aa <gettoken+0x5e>
 41b:	bf 61 00 00 00       	mov    $0x61,%edi
 420:	eb 88                	jmp    3aa <gettoken+0x5e>

  while(s < es && strchr(whitespace, *s))
    s++;
 422:	43                   	inc    %ebx
  while(s < es && strchr(whitespace, *s))
 423:	39 f3                	cmp    %esi,%ebx
 425:	73 18                	jae    43f <gettoken+0xf3>
 427:	83 ec 08             	sub    $0x8,%esp
 42a:	0f be 03             	movsbl (%ebx),%eax
 42d:	50                   	push   %eax
 42e:	68 e8 15 00 00       	push   $0x15e8
 433:	e8 24 06 00 00       	call   a5c <strchr>
 438:	83 c4 10             	add    $0x10,%esp
 43b:	85 c0                	test   %eax,%eax
 43d:	75 e3                	jne    422 <gettoken+0xd6>
  *ps = s;
 43f:	8b 45 08             	mov    0x8(%ebp),%eax
 442:	89 18                	mov    %ebx,(%eax)
  return ret;
}
 444:	89 f8                	mov    %edi,%eax
 446:	8d 65 f4             	lea    -0xc(%ebp),%esp
 449:	5b                   	pop    %ebx
 44a:	5e                   	pop    %esi
 44b:	5f                   	pop    %edi
 44c:	5d                   	pop    %ebp
 44d:	c3                   	ret    

0000044e <peek>:

int
peek(char **ps, char *es, char *toks)
{
 44e:	f3 0f 1e fb          	endbr32 
 452:	55                   	push   %ebp
 453:	89 e5                	mov    %esp,%ebp
 455:	57                   	push   %edi
 456:	56                   	push   %esi
 457:	53                   	push   %ebx
 458:	83 ec 0c             	sub    $0xc,%esp
 45b:	8b 7d 08             	mov    0x8(%ebp),%edi
 45e:	8b 75 0c             	mov    0xc(%ebp),%esi
  char *s;

  s = *ps;
 461:	8b 1f                	mov    (%edi),%ebx
  while(s < es && strchr(whitespace, *s))
 463:	39 f3                	cmp    %esi,%ebx
 465:	73 1b                	jae    482 <peek+0x34>
 467:	83 ec 08             	sub    $0x8,%esp
 46a:	0f be 03             	movsbl (%ebx),%eax
 46d:	50                   	push   %eax
 46e:	68 e8 15 00 00       	push   $0x15e8
 473:	e8 e4 05 00 00       	call   a5c <strchr>
 478:	83 c4 10             	add    $0x10,%esp
 47b:	85 c0                	test   %eax,%eax
 47d:	74 03                	je     482 <peek+0x34>
    s++;
 47f:	43                   	inc    %ebx
 480:	eb e1                	jmp    463 <peek+0x15>
  *ps = s;
 482:	89 1f                	mov    %ebx,(%edi)
  return *s && strchr(toks, *s);
 484:	8a 03                	mov    (%ebx),%al
 486:	84 c0                	test   %al,%al
 488:	75 0d                	jne    497 <peek+0x49>
 48a:	b8 00 00 00 00       	mov    $0x0,%eax
}
 48f:	8d 65 f4             	lea    -0xc(%ebp),%esp
 492:	5b                   	pop    %ebx
 493:	5e                   	pop    %esi
 494:	5f                   	pop    %edi
 495:	5d                   	pop    %ebp
 496:	c3                   	ret    
  return *s && strchr(toks, *s);
 497:	83 ec 08             	sub    $0x8,%esp
 49a:	0f be c0             	movsbl %al,%eax
 49d:	50                   	push   %eax
 49e:	ff 75 10             	pushl  0x10(%ebp)
 4a1:	e8 b6 05 00 00       	call   a5c <strchr>
 4a6:	83 c4 10             	add    $0x10,%esp
 4a9:	85 c0                	test   %eax,%eax
 4ab:	74 07                	je     4b4 <peek+0x66>
 4ad:	b8 01 00 00 00       	mov    $0x1,%eax
 4b2:	eb db                	jmp    48f <peek+0x41>
 4b4:	b8 00 00 00 00       	mov    $0x0,%eax
 4b9:	eb d4                	jmp    48f <peek+0x41>

000004bb <parseredirs>:
  return cmd;
}

struct cmd*
parseredirs(struct cmd *cmd, char **ps, char *es)
{
 4bb:	f3 0f 1e fb          	endbr32 
 4bf:	55                   	push   %ebp
 4c0:	89 e5                	mov    %esp,%ebp
 4c2:	57                   	push   %edi
 4c3:	56                   	push   %esi
 4c4:	53                   	push   %ebx
 4c5:	83 ec 1c             	sub    $0x1c,%esp
 4c8:	8b 7d 0c             	mov    0xc(%ebp),%edi
 4cb:	8b 75 10             	mov    0x10(%ebp),%esi
  int tok;
  char *q, *eq;

  while(peek(ps, es, "<>")){
 4ce:	eb 28                	jmp    4f8 <parseredirs+0x3d>
    tok = gettoken(ps, es, 0, 0);
    if(gettoken(ps, es, &q, &eq) != 'a')
      panic("missing file for redirection");
 4d0:	83 ec 0c             	sub    $0xc,%esp
 4d3:	68 9c 0f 00 00       	push   $0xf9c
 4d8:	e8 72 fb ff ff       	call   4f <panic>
    switch(tok){
    case '<':
      cmd = redircmd(cmd, q, eq, O_RDONLY, 0);
 4dd:	83 ec 0c             	sub    $0xc,%esp
 4e0:	6a 00                	push   $0x0
 4e2:	6a 00                	push   $0x0
 4e4:	ff 75 e0             	pushl  -0x20(%ebp)
 4e7:	ff 75 e4             	pushl  -0x1c(%ebp)
 4ea:	ff 75 08             	pushl  0x8(%ebp)
 4ed:	e8 66 fd ff ff       	call   258 <redircmd>
 4f2:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
 4f5:	83 c4 20             	add    $0x20,%esp
  while(peek(ps, es, "<>")){
 4f8:	83 ec 04             	sub    $0x4,%esp
 4fb:	68 b9 0f 00 00       	push   $0xfb9
 500:	56                   	push   %esi
 501:	57                   	push   %edi
 502:	e8 47 ff ff ff       	call   44e <peek>
 507:	83 c4 10             	add    $0x10,%esp
 50a:	85 c0                	test   %eax,%eax
 50c:	74 76                	je     584 <parseredirs+0xc9>
    tok = gettoken(ps, es, 0, 0);
 50e:	6a 00                	push   $0x0
 510:	6a 00                	push   $0x0
 512:	56                   	push   %esi
 513:	57                   	push   %edi
 514:	e8 33 fe ff ff       	call   34c <gettoken>
 519:	89 c3                	mov    %eax,%ebx
    if(gettoken(ps, es, &q, &eq) != 'a')
 51b:	8d 45 e0             	lea    -0x20(%ebp),%eax
 51e:	50                   	push   %eax
 51f:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 522:	50                   	push   %eax
 523:	56                   	push   %esi
 524:	57                   	push   %edi
 525:	e8 22 fe ff ff       	call   34c <gettoken>
 52a:	83 c4 20             	add    $0x20,%esp
 52d:	83 f8 61             	cmp    $0x61,%eax
 530:	75 9e                	jne    4d0 <parseredirs+0x15>
    switch(tok){
 532:	83 fb 3c             	cmp    $0x3c,%ebx
 535:	74 a6                	je     4dd <parseredirs+0x22>
 537:	83 fb 3e             	cmp    $0x3e,%ebx
 53a:	74 25                	je     561 <parseredirs+0xa6>
 53c:	83 fb 2b             	cmp    $0x2b,%ebx
 53f:	75 b7                	jne    4f8 <parseredirs+0x3d>
    case '>':
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
      break;
    case '+':  // >>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
 541:	83 ec 0c             	sub    $0xc,%esp
 544:	6a 01                	push   $0x1
 546:	68 01 02 00 00       	push   $0x201
 54b:	ff 75 e0             	pushl  -0x20(%ebp)
 54e:	ff 75 e4             	pushl  -0x1c(%ebp)
 551:	ff 75 08             	pushl  0x8(%ebp)
 554:	e8 ff fc ff ff       	call   258 <redircmd>
 559:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
 55c:	83 c4 20             	add    $0x20,%esp
 55f:	eb 97                	jmp    4f8 <parseredirs+0x3d>
      cmd = redircmd(cmd, q, eq, O_WRONLY|O_CREATE, 1);
 561:	83 ec 0c             	sub    $0xc,%esp
 564:	6a 01                	push   $0x1
 566:	68 01 02 00 00       	push   $0x201
 56b:	ff 75 e0             	pushl  -0x20(%ebp)
 56e:	ff 75 e4             	pushl  -0x1c(%ebp)
 571:	ff 75 08             	pushl  0x8(%ebp)
 574:	e8 df fc ff ff       	call   258 <redircmd>
 579:	89 45 08             	mov    %eax,0x8(%ebp)
      break;
 57c:	83 c4 20             	add    $0x20,%esp
 57f:	e9 74 ff ff ff       	jmp    4f8 <parseredirs+0x3d>
    }
  }
  return cmd;
}
 584:	8b 45 08             	mov    0x8(%ebp),%eax
 587:	8d 65 f4             	lea    -0xc(%ebp),%esp
 58a:	5b                   	pop    %ebx
 58b:	5e                   	pop    %esi
 58c:	5f                   	pop    %edi
 58d:	5d                   	pop    %ebp
 58e:	c3                   	ret    

0000058f <parseexec>:
  return cmd;
}

struct cmd*
parseexec(char **ps, char *es)
{
 58f:	f3 0f 1e fb          	endbr32 
 593:	55                   	push   %ebp
 594:	89 e5                	mov    %esp,%ebp
 596:	57                   	push   %edi
 597:	56                   	push   %esi
 598:	53                   	push   %ebx
 599:	83 ec 30             	sub    $0x30,%esp
 59c:	8b 75 08             	mov    0x8(%ebp),%esi
 59f:	8b 7d 0c             	mov    0xc(%ebp),%edi
  char *q, *eq;
  int tok, argc;
  struct execcmd *cmd;
  struct cmd *ret;

  if(peek(ps, es, "("))
 5a2:	68 bc 0f 00 00       	push   $0xfbc
 5a7:	57                   	push   %edi
 5a8:	56                   	push   %esi
 5a9:	e8 a0 fe ff ff       	call   44e <peek>
 5ae:	83 c4 10             	add    $0x10,%esp
 5b1:	85 c0                	test   %eax,%eax
 5b3:	75 1d                	jne    5d2 <parseexec+0x43>
 5b5:	89 c3                	mov    %eax,%ebx
    return parseblock(ps, es);

  ret = execcmd();
 5b7:	e8 6e fc ff ff       	call   22a <execcmd>
 5bc:	89 45 d0             	mov    %eax,-0x30(%ebp)
  cmd = (struct execcmd*)ret;

  argc = 0;
  ret = parseredirs(ret, ps, es);
 5bf:	83 ec 04             	sub    $0x4,%esp
 5c2:	57                   	push   %edi
 5c3:	56                   	push   %esi
 5c4:	50                   	push   %eax
 5c5:	e8 f1 fe ff ff       	call   4bb <parseredirs>
 5ca:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  while(!peek(ps, es, "|)&;")){
 5cd:	83 c4 10             	add    $0x10,%esp
 5d0:	eb 3b                	jmp    60d <parseexec+0x7e>
    return parseblock(ps, es);
 5d2:	83 ec 08             	sub    $0x8,%esp
 5d5:	57                   	push   %edi
 5d6:	56                   	push   %esi
 5d7:	e8 95 01 00 00       	call   771 <parseblock>
 5dc:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 5df:	83 c4 10             	add    $0x10,%esp
    ret = parseredirs(ret, ps, es);
  }
  cmd->argv[argc] = 0;
  cmd->eargv[argc] = 0;
  return ret;
}
 5e2:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 5e5:	8d 65 f4             	lea    -0xc(%ebp),%esp
 5e8:	5b                   	pop    %ebx
 5e9:	5e                   	pop    %esi
 5ea:	5f                   	pop    %edi
 5eb:	5d                   	pop    %ebp
 5ec:	c3                   	ret    
      panic("syntax");
 5ed:	83 ec 0c             	sub    $0xc,%esp
 5f0:	68 be 0f 00 00       	push   $0xfbe
 5f5:	e8 55 fa ff ff       	call   4f <panic>
    ret = parseredirs(ret, ps, es);
 5fa:	83 ec 04             	sub    $0x4,%esp
 5fd:	57                   	push   %edi
 5fe:	56                   	push   %esi
 5ff:	ff 75 d4             	pushl  -0x2c(%ebp)
 602:	e8 b4 fe ff ff       	call   4bb <parseredirs>
 607:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 60a:	83 c4 10             	add    $0x10,%esp
  while(!peek(ps, es, "|)&;")){
 60d:	83 ec 04             	sub    $0x4,%esp
 610:	68 d3 0f 00 00       	push   $0xfd3
 615:	57                   	push   %edi
 616:	56                   	push   %esi
 617:	e8 32 fe ff ff       	call   44e <peek>
 61c:	83 c4 10             	add    $0x10,%esp
 61f:	85 c0                	test   %eax,%eax
 621:	75 3f                	jne    662 <parseexec+0xd3>
    if((tok=gettoken(ps, es, &q, &eq)) == 0)
 623:	8d 45 e0             	lea    -0x20(%ebp),%eax
 626:	50                   	push   %eax
 627:	8d 45 e4             	lea    -0x1c(%ebp),%eax
 62a:	50                   	push   %eax
 62b:	57                   	push   %edi
 62c:	56                   	push   %esi
 62d:	e8 1a fd ff ff       	call   34c <gettoken>
 632:	83 c4 10             	add    $0x10,%esp
 635:	85 c0                	test   %eax,%eax
 637:	74 29                	je     662 <parseexec+0xd3>
    if(tok != 'a')
 639:	83 f8 61             	cmp    $0x61,%eax
 63c:	75 af                	jne    5ed <parseexec+0x5e>
    cmd->argv[argc] = q;
 63e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 641:	8b 55 d0             	mov    -0x30(%ebp),%edx
 644:	89 44 9a 04          	mov    %eax,0x4(%edx,%ebx,4)
    cmd->eargv[argc] = eq;
 648:	8b 45 e0             	mov    -0x20(%ebp),%eax
 64b:	89 44 9a 2c          	mov    %eax,0x2c(%edx,%ebx,4)
    argc++;
 64f:	43                   	inc    %ebx
    if(argc >= MAXARGS)
 650:	83 fb 09             	cmp    $0x9,%ebx
 653:	7e a5                	jle    5fa <parseexec+0x6b>
      panic("too many args");
 655:	83 ec 0c             	sub    $0xc,%esp
 658:	68 c5 0f 00 00       	push   $0xfc5
 65d:	e8 ed f9 ff ff       	call   4f <panic>
  cmd->argv[argc] = 0;
 662:	8b 45 d0             	mov    -0x30(%ebp),%eax
 665:	c7 44 98 04 00 00 00 	movl   $0x0,0x4(%eax,%ebx,4)
 66c:	00 
  cmd->eargv[argc] = 0;
 66d:	c7 44 98 2c 00 00 00 	movl   $0x0,0x2c(%eax,%ebx,4)
 674:	00 
  return ret;
 675:	e9 68 ff ff ff       	jmp    5e2 <parseexec+0x53>

0000067a <parsepipe>:
{
 67a:	f3 0f 1e fb          	endbr32 
 67e:	55                   	push   %ebp
 67f:	89 e5                	mov    %esp,%ebp
 681:	57                   	push   %edi
 682:	56                   	push   %esi
 683:	53                   	push   %ebx
 684:	83 ec 14             	sub    $0x14,%esp
 687:	8b 75 08             	mov    0x8(%ebp),%esi
 68a:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parseexec(ps, es);
 68d:	57                   	push   %edi
 68e:	56                   	push   %esi
 68f:	e8 fb fe ff ff       	call   58f <parseexec>
 694:	89 c3                	mov    %eax,%ebx
  if(peek(ps, es, "|")){
 696:	83 c4 0c             	add    $0xc,%esp
 699:	68 d8 0f 00 00       	push   $0xfd8
 69e:	57                   	push   %edi
 69f:	56                   	push   %esi
 6a0:	e8 a9 fd ff ff       	call   44e <peek>
 6a5:	83 c4 10             	add    $0x10,%esp
 6a8:	85 c0                	test   %eax,%eax
 6aa:	75 0a                	jne    6b6 <parsepipe+0x3c>
}
 6ac:	89 d8                	mov    %ebx,%eax
 6ae:	8d 65 f4             	lea    -0xc(%ebp),%esp
 6b1:	5b                   	pop    %ebx
 6b2:	5e                   	pop    %esi
 6b3:	5f                   	pop    %edi
 6b4:	5d                   	pop    %ebp
 6b5:	c3                   	ret    
    gettoken(ps, es, 0, 0);
 6b6:	6a 00                	push   $0x0
 6b8:	6a 00                	push   $0x0
 6ba:	57                   	push   %edi
 6bb:	56                   	push   %esi
 6bc:	e8 8b fc ff ff       	call   34c <gettoken>
    cmd = pipecmd(cmd, parsepipe(ps, es));
 6c1:	83 c4 08             	add    $0x8,%esp
 6c4:	57                   	push   %edi
 6c5:	56                   	push   %esi
 6c6:	e8 af ff ff ff       	call   67a <parsepipe>
 6cb:	83 c4 08             	add    $0x8,%esp
 6ce:	50                   	push   %eax
 6cf:	53                   	push   %ebx
 6d0:	e8 cf fb ff ff       	call   2a4 <pipecmd>
 6d5:	89 c3                	mov    %eax,%ebx
 6d7:	83 c4 10             	add    $0x10,%esp
  return cmd;
 6da:	eb d0                	jmp    6ac <parsepipe+0x32>

000006dc <parseline>:
{
 6dc:	f3 0f 1e fb          	endbr32 
 6e0:	55                   	push   %ebp
 6e1:	89 e5                	mov    %esp,%ebp
 6e3:	57                   	push   %edi
 6e4:	56                   	push   %esi
 6e5:	53                   	push   %ebx
 6e6:	83 ec 14             	sub    $0x14,%esp
 6e9:	8b 75 08             	mov    0x8(%ebp),%esi
 6ec:	8b 7d 0c             	mov    0xc(%ebp),%edi
  cmd = parsepipe(ps, es);
 6ef:	57                   	push   %edi
 6f0:	56                   	push   %esi
 6f1:	e8 84 ff ff ff       	call   67a <parsepipe>
 6f6:	89 c3                	mov    %eax,%ebx
  while(peek(ps, es, "&")){
 6f8:	83 c4 10             	add    $0x10,%esp
 6fb:	83 ec 04             	sub    $0x4,%esp
 6fe:	68 da 0f 00 00       	push   $0xfda
 703:	57                   	push   %edi
 704:	56                   	push   %esi
 705:	e8 44 fd ff ff       	call   44e <peek>
 70a:	83 c4 10             	add    $0x10,%esp
 70d:	85 c0                	test   %eax,%eax
 70f:	74 1a                	je     72b <parseline+0x4f>
    gettoken(ps, es, 0, 0);
 711:	6a 00                	push   $0x0
 713:	6a 00                	push   $0x0
 715:	57                   	push   %edi
 716:	56                   	push   %esi
 717:	e8 30 fc ff ff       	call   34c <gettoken>
    cmd = backcmd(cmd);
 71c:	89 1c 24             	mov    %ebx,(%esp)
 71f:	e8 f4 fb ff ff       	call   318 <backcmd>
 724:	89 c3                	mov    %eax,%ebx
 726:	83 c4 10             	add    $0x10,%esp
 729:	eb d0                	jmp    6fb <parseline+0x1f>
  if(peek(ps, es, ";")){
 72b:	83 ec 04             	sub    $0x4,%esp
 72e:	68 d6 0f 00 00       	push   $0xfd6
 733:	57                   	push   %edi
 734:	56                   	push   %esi
 735:	e8 14 fd ff ff       	call   44e <peek>
 73a:	83 c4 10             	add    $0x10,%esp
 73d:	85 c0                	test   %eax,%eax
 73f:	75 0a                	jne    74b <parseline+0x6f>
}
 741:	89 d8                	mov    %ebx,%eax
 743:	8d 65 f4             	lea    -0xc(%ebp),%esp
 746:	5b                   	pop    %ebx
 747:	5e                   	pop    %esi
 748:	5f                   	pop    %edi
 749:	5d                   	pop    %ebp
 74a:	c3                   	ret    
    gettoken(ps, es, 0, 0);
 74b:	6a 00                	push   $0x0
 74d:	6a 00                	push   $0x0
 74f:	57                   	push   %edi
 750:	56                   	push   %esi
 751:	e8 f6 fb ff ff       	call   34c <gettoken>
    cmd = listcmd(cmd, parseline(ps, es));
 756:	83 c4 08             	add    $0x8,%esp
 759:	57                   	push   %edi
 75a:	56                   	push   %esi
 75b:	e8 7c ff ff ff       	call   6dc <parseline>
 760:	83 c4 08             	add    $0x8,%esp
 763:	50                   	push   %eax
 764:	53                   	push   %ebx
 765:	e8 74 fb ff ff       	call   2de <listcmd>
 76a:	89 c3                	mov    %eax,%ebx
 76c:	83 c4 10             	add    $0x10,%esp
  return cmd;
 76f:	eb d0                	jmp    741 <parseline+0x65>

00000771 <parseblock>:
{
 771:	f3 0f 1e fb          	endbr32 
 775:	55                   	push   %ebp
 776:	89 e5                	mov    %esp,%ebp
 778:	57                   	push   %edi
 779:	56                   	push   %esi
 77a:	53                   	push   %ebx
 77b:	83 ec 10             	sub    $0x10,%esp
 77e:	8b 5d 08             	mov    0x8(%ebp),%ebx
 781:	8b 75 0c             	mov    0xc(%ebp),%esi
  if(!peek(ps, es, "("))
 784:	68 bc 0f 00 00       	push   $0xfbc
 789:	56                   	push   %esi
 78a:	53                   	push   %ebx
 78b:	e8 be fc ff ff       	call   44e <peek>
 790:	83 c4 10             	add    $0x10,%esp
 793:	85 c0                	test   %eax,%eax
 795:	74 4b                	je     7e2 <parseblock+0x71>
  gettoken(ps, es, 0, 0);
 797:	6a 00                	push   $0x0
 799:	6a 00                	push   $0x0
 79b:	56                   	push   %esi
 79c:	53                   	push   %ebx
 79d:	e8 aa fb ff ff       	call   34c <gettoken>
  cmd = parseline(ps, es);
 7a2:	83 c4 08             	add    $0x8,%esp
 7a5:	56                   	push   %esi
 7a6:	53                   	push   %ebx
 7a7:	e8 30 ff ff ff       	call   6dc <parseline>
 7ac:	89 c7                	mov    %eax,%edi
  if(!peek(ps, es, ")"))
 7ae:	83 c4 0c             	add    $0xc,%esp
 7b1:	68 f8 0f 00 00       	push   $0xff8
 7b6:	56                   	push   %esi
 7b7:	53                   	push   %ebx
 7b8:	e8 91 fc ff ff       	call   44e <peek>
 7bd:	83 c4 10             	add    $0x10,%esp
 7c0:	85 c0                	test   %eax,%eax
 7c2:	74 2b                	je     7ef <parseblock+0x7e>
  gettoken(ps, es, 0, 0);
 7c4:	6a 00                	push   $0x0
 7c6:	6a 00                	push   $0x0
 7c8:	56                   	push   %esi
 7c9:	53                   	push   %ebx
 7ca:	e8 7d fb ff ff       	call   34c <gettoken>
  cmd = parseredirs(cmd, ps, es);
 7cf:	83 c4 0c             	add    $0xc,%esp
 7d2:	56                   	push   %esi
 7d3:	53                   	push   %ebx
 7d4:	57                   	push   %edi
 7d5:	e8 e1 fc ff ff       	call   4bb <parseredirs>
}
 7da:	8d 65 f4             	lea    -0xc(%ebp),%esp
 7dd:	5b                   	pop    %ebx
 7de:	5e                   	pop    %esi
 7df:	5f                   	pop    %edi
 7e0:	5d                   	pop    %ebp
 7e1:	c3                   	ret    
    panic("parseblock");
 7e2:	83 ec 0c             	sub    $0xc,%esp
 7e5:	68 dc 0f 00 00       	push   $0xfdc
 7ea:	e8 60 f8 ff ff       	call   4f <panic>
    panic("syntax - missing )");
 7ef:	83 ec 0c             	sub    $0xc,%esp
 7f2:	68 e7 0f 00 00       	push   $0xfe7
 7f7:	e8 53 f8 ff ff       	call   4f <panic>

000007fc <nulterminate>:

// NUL-terminate all the counted strings.
struct cmd*
nulterminate(struct cmd *cmd)
{
 7fc:	f3 0f 1e fb          	endbr32 
 800:	55                   	push   %ebp
 801:	89 e5                	mov    %esp,%ebp
 803:	53                   	push   %ebx
 804:	83 ec 04             	sub    $0x4,%esp
 807:	8b 5d 08             	mov    0x8(%ebp),%ebx
  struct execcmd *ecmd;
  struct listcmd *lcmd;
  struct pipecmd *pcmd;
  struct redircmd *rcmd;

  if(cmd == 0)
 80a:	85 db                	test   %ebx,%ebx
 80c:	74 39                	je     847 <nulterminate+0x4b>
    return 0;

  switch(cmd->type){
 80e:	8b 03                	mov    (%ebx),%eax
 810:	83 f8 05             	cmp    $0x5,%eax
 813:	77 32                	ja     847 <nulterminate+0x4b>
 815:	3e ff 24 85 38 10 00 	notrack jmp *0x1038(,%eax,4)
 81c:	00 
 81d:	b8 00 00 00 00       	mov    $0x0,%eax
  case EXEC:
    ecmd = (struct execcmd*)cmd;
    for(i=0; ecmd->argv[i]; i++)
 822:	83 7c 83 04 00       	cmpl   $0x0,0x4(%ebx,%eax,4)
 827:	74 1e                	je     847 <nulterminate+0x4b>
      *ecmd->eargv[i] = 0;
 829:	8b 54 83 2c          	mov    0x2c(%ebx,%eax,4),%edx
 82d:	c6 02 00             	movb   $0x0,(%edx)
    for(i=0; ecmd->argv[i]; i++)
 830:	40                   	inc    %eax
 831:	eb ef                	jmp    822 <nulterminate+0x26>
    break;

  case REDIR:
    rcmd = (struct redircmd*)cmd;
    nulterminate(rcmd->cmd);
 833:	83 ec 0c             	sub    $0xc,%esp
 836:	ff 73 04             	pushl  0x4(%ebx)
 839:	e8 be ff ff ff       	call   7fc <nulterminate>
    *rcmd->efile = 0;
 83e:	8b 43 0c             	mov    0xc(%ebx),%eax
 841:	c6 00 00             	movb   $0x0,(%eax)
    break;
 844:	83 c4 10             	add    $0x10,%esp
    bcmd = (struct backcmd*)cmd;
    nulterminate(bcmd->cmd);
    break;
  }
  return cmd;
}
 847:	89 d8                	mov    %ebx,%eax
 849:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 84c:	c9                   	leave  
 84d:	c3                   	ret    
    nulterminate(pcmd->left);
 84e:	83 ec 0c             	sub    $0xc,%esp
 851:	ff 73 04             	pushl  0x4(%ebx)
 854:	e8 a3 ff ff ff       	call   7fc <nulterminate>
    nulterminate(pcmd->right);
 859:	83 c4 04             	add    $0x4,%esp
 85c:	ff 73 08             	pushl  0x8(%ebx)
 85f:	e8 98 ff ff ff       	call   7fc <nulterminate>
    break;
 864:	83 c4 10             	add    $0x10,%esp
 867:	eb de                	jmp    847 <nulterminate+0x4b>
    nulterminate(lcmd->left);
 869:	83 ec 0c             	sub    $0xc,%esp
 86c:	ff 73 04             	pushl  0x4(%ebx)
 86f:	e8 88 ff ff ff       	call   7fc <nulterminate>
    nulterminate(lcmd->right);
 874:	83 c4 04             	add    $0x4,%esp
 877:	ff 73 08             	pushl  0x8(%ebx)
 87a:	e8 7d ff ff ff       	call   7fc <nulterminate>
    break;
 87f:	83 c4 10             	add    $0x10,%esp
 882:	eb c3                	jmp    847 <nulterminate+0x4b>
    nulterminate(bcmd->cmd);
 884:	83 ec 0c             	sub    $0xc,%esp
 887:	ff 73 04             	pushl  0x4(%ebx)
 88a:	e8 6d ff ff ff       	call   7fc <nulterminate>
    break;
 88f:	83 c4 10             	add    $0x10,%esp
 892:	eb b3                	jmp    847 <nulterminate+0x4b>

00000894 <parsecmd>:
{
 894:	f3 0f 1e fb          	endbr32 
 898:	55                   	push   %ebp
 899:	89 e5                	mov    %esp,%ebp
 89b:	56                   	push   %esi
 89c:	53                   	push   %ebx
  es = s + strlen(s);
 89d:	8b 5d 08             	mov    0x8(%ebp),%ebx
 8a0:	83 ec 0c             	sub    $0xc,%esp
 8a3:	53                   	push   %ebx
 8a4:	e8 7f 01 00 00       	call   a28 <strlen>
 8a9:	01 c3                	add    %eax,%ebx
  cmd = parseline(&s, es);
 8ab:	83 c4 08             	add    $0x8,%esp
 8ae:	53                   	push   %ebx
 8af:	8d 45 08             	lea    0x8(%ebp),%eax
 8b2:	50                   	push   %eax
 8b3:	e8 24 fe ff ff       	call   6dc <parseline>
 8b8:	89 c6                	mov    %eax,%esi
  peek(&s, es, "");
 8ba:	83 c4 0c             	add    $0xc,%esp
 8bd:	68 86 0f 00 00       	push   $0xf86
 8c2:	53                   	push   %ebx
 8c3:	8d 45 08             	lea    0x8(%ebp),%eax
 8c6:	50                   	push   %eax
 8c7:	e8 82 fb ff ff       	call   44e <peek>
  if(s != es){
 8cc:	8b 45 08             	mov    0x8(%ebp),%eax
 8cf:	83 c4 10             	add    $0x10,%esp
 8d2:	39 d8                	cmp    %ebx,%eax
 8d4:	75 12                	jne    8e8 <parsecmd+0x54>
  nulterminate(cmd);
 8d6:	83 ec 0c             	sub    $0xc,%esp
 8d9:	56                   	push   %esi
 8da:	e8 1d ff ff ff       	call   7fc <nulterminate>
}
 8df:	89 f0                	mov    %esi,%eax
 8e1:	8d 65 f8             	lea    -0x8(%ebp),%esp
 8e4:	5b                   	pop    %ebx
 8e5:	5e                   	pop    %esi
 8e6:	5d                   	pop    %ebp
 8e7:	c3                   	ret    
    printf(2, "leftovers: %s\n", s);
 8e8:	83 ec 04             	sub    $0x4,%esp
 8eb:	50                   	push   %eax
 8ec:	68 fa 0f 00 00       	push   $0xffa
 8f1:	6a 02                	push   $0x2
 8f3:	e8 c6 03 00 00       	call   cbe <printf>
    panic("syntax");
 8f8:	c7 04 24 be 0f 00 00 	movl   $0xfbe,(%esp)
 8ff:	e8 4b f7 ff ff       	call   4f <panic>

00000904 <main>:
{
 904:	f3 0f 1e fb          	endbr32 
 908:	8d 4c 24 04          	lea    0x4(%esp),%ecx
 90c:	83 e4 f0             	and    $0xfffffff0,%esp
 90f:	ff 71 fc             	pushl  -0x4(%ecx)
 912:	55                   	push   %ebp
 913:	89 e5                	mov    %esp,%ebp
 915:	51                   	push   %ecx
 916:	83 ec 04             	sub    $0x4,%esp
  while((fd = open("console", O_RDWR)) >= 0){
 919:	83 ec 08             	sub    $0x8,%esp
 91c:	6a 02                	push   $0x2
 91e:	68 09 10 00 00       	push   $0x1009
 923:	e8 97 02 00 00       	call   bbf <open>
 928:	83 c4 10             	add    $0x10,%esp
 92b:	85 c0                	test   %eax,%eax
 92d:	78 21                	js     950 <main+0x4c>
    if(fd >= 3){
 92f:	83 f8 02             	cmp    $0x2,%eax
 932:	7e e5                	jle    919 <main+0x15>
      close(fd);
 934:	83 ec 0c             	sub    $0xc,%esp
 937:	50                   	push   %eax
 938:	e8 6a 02 00 00       	call   ba7 <close>
      break;
 93d:	83 c4 10             	add    $0x10,%esp
 940:	eb 0e                	jmp    950 <main+0x4c>
    if(fork1() == 0)
 942:	e8 26 f7 ff ff       	call   6d <fork1>
 947:	85 c0                	test   %eax,%eax
 949:	74 76                	je     9c1 <main+0xbd>
    wait();
 94b:	e8 37 02 00 00       	call   b87 <wait>
  while(getcmd(buf, sizeof(buf)) >= 0){
 950:	83 ec 08             	sub    $0x8,%esp
 953:	6a 64                	push   $0x64
 955:	68 00 16 00 00       	push   $0x1600
 95a:	e8 a1 f6 ff ff       	call   0 <getcmd>
 95f:	83 c4 10             	add    $0x10,%esp
 962:	85 c0                	test   %eax,%eax
 964:	78 70                	js     9d6 <main+0xd2>
    if(buf[0] == 'c' && buf[1] == 'd' && buf[2] == ' '){
 966:	80 3d 00 16 00 00 63 	cmpb   $0x63,0x1600
 96d:	75 d3                	jne    942 <main+0x3e>
 96f:	80 3d 01 16 00 00 64 	cmpb   $0x64,0x1601
 976:	75 ca                	jne    942 <main+0x3e>
 978:	80 3d 02 16 00 00 20 	cmpb   $0x20,0x1602
 97f:	75 c1                	jne    942 <main+0x3e>
      buf[strlen(buf)-1] = 0;  // chop \n
 981:	83 ec 0c             	sub    $0xc,%esp
 984:	68 00 16 00 00       	push   $0x1600
 989:	e8 9a 00 00 00       	call   a28 <strlen>
 98e:	c6 80 ff 15 00 00 00 	movb   $0x0,0x15ff(%eax)
      if(chdir(buf+3) < 0)
 995:	c7 04 24 03 16 00 00 	movl   $0x1603,(%esp)
 99c:	e8 4e 02 00 00       	call   bef <chdir>
 9a1:	83 c4 10             	add    $0x10,%esp
 9a4:	85 c0                	test   %eax,%eax
 9a6:	79 a8                	jns    950 <main+0x4c>
        printf(2, "cannot cd %s\n", buf+3);
 9a8:	83 ec 04             	sub    $0x4,%esp
 9ab:	68 03 16 00 00       	push   $0x1603
 9b0:	68 11 10 00 00       	push   $0x1011
 9b5:	6a 02                	push   $0x2
 9b7:	e8 02 03 00 00       	call   cbe <printf>
 9bc:	83 c4 10             	add    $0x10,%esp
      continue;
 9bf:	eb 8f                	jmp    950 <main+0x4c>
      runcmd(parsecmd(buf));
 9c1:	83 ec 0c             	sub    $0xc,%esp
 9c4:	68 00 16 00 00       	push   $0x1600
 9c9:	e8 c6 fe ff ff       	call   894 <parsecmd>
 9ce:	89 04 24             	mov    %eax,(%esp)
 9d1:	e8 ba f6 ff ff       	call   90 <runcmd>
  exit();
 9d6:	e8 a4 01 00 00       	call   b7f <exit>

000009db <start>:
#include <x86.h>

// Entry point of the library	
void
start()
{
 9db:	f3 0f 1e fb          	endbr32 
}
 9df:	c3                   	ret    

000009e0 <strcpy>:

char*
strcpy(char *s, const char *t)
{
 9e0:	f3 0f 1e fb          	endbr32 
 9e4:	55                   	push   %ebp
 9e5:	89 e5                	mov    %esp,%ebp
 9e7:	56                   	push   %esi
 9e8:	53                   	push   %ebx
 9e9:	8b 45 08             	mov    0x8(%ebp),%eax
 9ec:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  char *os;

  os = s;
  while((*s++ = *t++) != 0)
 9ef:	89 c2                	mov    %eax,%edx
 9f1:	89 cb                	mov    %ecx,%ebx
 9f3:	41                   	inc    %ecx
 9f4:	89 d6                	mov    %edx,%esi
 9f6:	42                   	inc    %edx
 9f7:	8a 1b                	mov    (%ebx),%bl
 9f9:	88 1e                	mov    %bl,(%esi)
 9fb:	84 db                	test   %bl,%bl
 9fd:	75 f2                	jne    9f1 <strcpy+0x11>
    ;
  return os;
}
 9ff:	5b                   	pop    %ebx
 a00:	5e                   	pop    %esi
 a01:	5d                   	pop    %ebp
 a02:	c3                   	ret    

00000a03 <strcmp>:

int
strcmp(const char *p, const char *q)
{
 a03:	f3 0f 1e fb          	endbr32 
 a07:	55                   	push   %ebp
 a08:	89 e5                	mov    %esp,%ebp
 a0a:	8b 4d 08             	mov    0x8(%ebp),%ecx
 a0d:	8b 55 0c             	mov    0xc(%ebp),%edx
  while(*p && *p == *q)
 a10:	8a 01                	mov    (%ecx),%al
 a12:	84 c0                	test   %al,%al
 a14:	74 08                	je     a1e <strcmp+0x1b>
 a16:	3a 02                	cmp    (%edx),%al
 a18:	75 04                	jne    a1e <strcmp+0x1b>
    p++, q++;
 a1a:	41                   	inc    %ecx
 a1b:	42                   	inc    %edx
 a1c:	eb f2                	jmp    a10 <strcmp+0xd>
  return (uchar)*p - (uchar)*q;
 a1e:	0f b6 c0             	movzbl %al,%eax
 a21:	0f b6 12             	movzbl (%edx),%edx
 a24:	29 d0                	sub    %edx,%eax
}
 a26:	5d                   	pop    %ebp
 a27:	c3                   	ret    

00000a28 <strlen>:

uint
strlen(const char *s)
{
 a28:	f3 0f 1e fb          	endbr32 
 a2c:	55                   	push   %ebp
 a2d:	89 e5                	mov    %esp,%ebp
 a2f:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  for(n = 0; s[n]; n++)
 a32:	b8 00 00 00 00       	mov    $0x0,%eax
 a37:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
 a3b:	74 03                	je     a40 <strlen+0x18>
 a3d:	40                   	inc    %eax
 a3e:	eb f7                	jmp    a37 <strlen+0xf>
    ;
  return n;
}
 a40:	5d                   	pop    %ebp
 a41:	c3                   	ret    

00000a42 <memset>:

void*
memset(void *dst, int c, uint n)
{
 a42:	f3 0f 1e fb          	endbr32 
 a46:	55                   	push   %ebp
 a47:	89 e5                	mov    %esp,%ebp
 a49:	57                   	push   %edi
}

static inline void
stosb(void *addr, int data, int cnt)
{
  asm volatile("cld; rep stosb" :
 a4a:	8b 7d 08             	mov    0x8(%ebp),%edi
 a4d:	8b 4d 10             	mov    0x10(%ebp),%ecx
 a50:	8b 45 0c             	mov    0xc(%ebp),%eax
 a53:	fc                   	cld    
 a54:	f3 aa                	rep stos %al,%es:(%edi)
  stosb(dst, c, n);
  return dst;
}
 a56:	8b 45 08             	mov    0x8(%ebp),%eax
 a59:	5f                   	pop    %edi
 a5a:	5d                   	pop    %ebp
 a5b:	c3                   	ret    

00000a5c <strchr>:

char*
strchr(const char *s, char c)
{
 a5c:	f3 0f 1e fb          	endbr32 
 a60:	55                   	push   %ebp
 a61:	89 e5                	mov    %esp,%ebp
 a63:	8b 45 08             	mov    0x8(%ebp),%eax
 a66:	8a 4d 0c             	mov    0xc(%ebp),%cl
  for(; *s; s++)
 a69:	8a 10                	mov    (%eax),%dl
 a6b:	84 d2                	test   %dl,%dl
 a6d:	74 07                	je     a76 <strchr+0x1a>
    if(*s == c)
 a6f:	38 ca                	cmp    %cl,%dl
 a71:	74 08                	je     a7b <strchr+0x1f>
  for(; *s; s++)
 a73:	40                   	inc    %eax
 a74:	eb f3                	jmp    a69 <strchr+0xd>
      return (char*)s;
  return 0;
 a76:	b8 00 00 00 00       	mov    $0x0,%eax
}
 a7b:	5d                   	pop    %ebp
 a7c:	c3                   	ret    

00000a7d <gets>:

char*
gets(char *buf, int max)
{
 a7d:	f3 0f 1e fb          	endbr32 
 a81:	55                   	push   %ebp
 a82:	89 e5                	mov    %esp,%ebp
 a84:	57                   	push   %edi
 a85:	56                   	push   %esi
 a86:	53                   	push   %ebx
 a87:	83 ec 1c             	sub    $0x1c,%esp
 a8a:	8b 7d 08             	mov    0x8(%ebp),%edi
  int i, cc;
  char c;

  for(i=0; i+1 < max; ){
 a8d:	bb 00 00 00 00       	mov    $0x0,%ebx
 a92:	89 de                	mov    %ebx,%esi
 a94:	43                   	inc    %ebx
 a95:	3b 5d 0c             	cmp    0xc(%ebp),%ebx
 a98:	7d 2b                	jge    ac5 <gets+0x48>
    cc = read(0, &c, 1);
 a9a:	83 ec 04             	sub    $0x4,%esp
 a9d:	6a 01                	push   $0x1
 a9f:	8d 45 e7             	lea    -0x19(%ebp),%eax
 aa2:	50                   	push   %eax
 aa3:	6a 00                	push   $0x0
 aa5:	e8 ed 00 00 00       	call   b97 <read>
    if(cc < 1)
 aaa:	83 c4 10             	add    $0x10,%esp
 aad:	85 c0                	test   %eax,%eax
 aaf:	7e 14                	jle    ac5 <gets+0x48>
      break;
    buf[i++] = c;
 ab1:	8a 45 e7             	mov    -0x19(%ebp),%al
 ab4:	88 04 37             	mov    %al,(%edi,%esi,1)
    if(c == '\n' || c == '\r')
 ab7:	3c 0a                	cmp    $0xa,%al
 ab9:	74 08                	je     ac3 <gets+0x46>
 abb:	3c 0d                	cmp    $0xd,%al
 abd:	75 d3                	jne    a92 <gets+0x15>
    buf[i++] = c;
 abf:	89 de                	mov    %ebx,%esi
 ac1:	eb 02                	jmp    ac5 <gets+0x48>
 ac3:	89 de                	mov    %ebx,%esi
      break;
  }
  buf[i] = '\0';
 ac5:	c6 04 37 00          	movb   $0x0,(%edi,%esi,1)
  return buf;
}
 ac9:	89 f8                	mov    %edi,%eax
 acb:	8d 65 f4             	lea    -0xc(%ebp),%esp
 ace:	5b                   	pop    %ebx
 acf:	5e                   	pop    %esi
 ad0:	5f                   	pop    %edi
 ad1:	5d                   	pop    %ebp
 ad2:	c3                   	ret    

00000ad3 <stat>:

int
stat(const char *n, struct stat *st)
{
 ad3:	f3 0f 1e fb          	endbr32 
 ad7:	55                   	push   %ebp
 ad8:	89 e5                	mov    %esp,%ebp
 ada:	56                   	push   %esi
 adb:	53                   	push   %ebx
  int fd;
  int r;

  fd = open(n, O_RDONLY);
 adc:	83 ec 08             	sub    $0x8,%esp
 adf:	6a 00                	push   $0x0
 ae1:	ff 75 08             	pushl  0x8(%ebp)
 ae4:	e8 d6 00 00 00       	call   bbf <open>
  if(fd < 0)
 ae9:	83 c4 10             	add    $0x10,%esp
 aec:	85 c0                	test   %eax,%eax
 aee:	78 24                	js     b14 <stat+0x41>
 af0:	89 c3                	mov    %eax,%ebx
    return -1;
  r = fstat(fd, st);
 af2:	83 ec 08             	sub    $0x8,%esp
 af5:	ff 75 0c             	pushl  0xc(%ebp)
 af8:	50                   	push   %eax
 af9:	e8 d9 00 00 00       	call   bd7 <fstat>
 afe:	89 c6                	mov    %eax,%esi
  close(fd);
 b00:	89 1c 24             	mov    %ebx,(%esp)
 b03:	e8 9f 00 00 00       	call   ba7 <close>
  return r;
 b08:	83 c4 10             	add    $0x10,%esp
}
 b0b:	89 f0                	mov    %esi,%eax
 b0d:	8d 65 f8             	lea    -0x8(%ebp),%esp
 b10:	5b                   	pop    %ebx
 b11:	5e                   	pop    %esi
 b12:	5d                   	pop    %ebp
 b13:	c3                   	ret    
    return -1;
 b14:	be ff ff ff ff       	mov    $0xffffffff,%esi
 b19:	eb f0                	jmp    b0b <stat+0x38>

00000b1b <atoi>:

int
atoi(const char *s)
{
 b1b:	f3 0f 1e fb          	endbr32 
 b1f:	55                   	push   %ebp
 b20:	89 e5                	mov    %esp,%ebp
 b22:	53                   	push   %ebx
 b23:	8b 4d 08             	mov    0x8(%ebp),%ecx
  int n;

  n = 0;
 b26:	ba 00 00 00 00       	mov    $0x0,%edx
  while('0' <= *s && *s <= '9')
 b2b:	8a 01                	mov    (%ecx),%al
 b2d:	8d 58 d0             	lea    -0x30(%eax),%ebx
 b30:	80 fb 09             	cmp    $0x9,%bl
 b33:	77 10                	ja     b45 <atoi+0x2a>
    n = n*10 + *s++ - '0';
 b35:	8d 14 92             	lea    (%edx,%edx,4),%edx
 b38:	8d 1c 12             	lea    (%edx,%edx,1),%ebx
 b3b:	41                   	inc    %ecx
 b3c:	0f be c0             	movsbl %al,%eax
 b3f:	8d 54 18 d0          	lea    -0x30(%eax,%ebx,1),%edx
 b43:	eb e6                	jmp    b2b <atoi+0x10>
  return n;
}
 b45:	89 d0                	mov    %edx,%eax
 b47:	5b                   	pop    %ebx
 b48:	5d                   	pop    %ebp
 b49:	c3                   	ret    

00000b4a <memmove>:

void*
memmove(void *vdst, const void *vsrc, int n)
{
 b4a:	f3 0f 1e fb          	endbr32 
 b4e:	55                   	push   %ebp
 b4f:	89 e5                	mov    %esp,%ebp
 b51:	56                   	push   %esi
 b52:	53                   	push   %ebx
 b53:	8b 45 08             	mov    0x8(%ebp),%eax
 b56:	8b 5d 0c             	mov    0xc(%ebp),%ebx
 b59:	8b 55 10             	mov    0x10(%ebp),%edx
  char *dst;
  const char *src;

  dst = vdst;
 b5c:	89 c1                	mov    %eax,%ecx
  src = vsrc;
  while(n-- > 0)
 b5e:	8d 72 ff             	lea    -0x1(%edx),%esi
 b61:	85 d2                	test   %edx,%edx
 b63:	7e 0e                	jle    b73 <memmove+0x29>
    *dst++ = *src++;
 b65:	8a 13                	mov    (%ebx),%dl
 b67:	88 11                	mov    %dl,(%ecx)
 b69:	8d 5b 01             	lea    0x1(%ebx),%ebx
 b6c:	8d 49 01             	lea    0x1(%ecx),%ecx
  while(n-- > 0)
 b6f:	89 f2                	mov    %esi,%edx
 b71:	eb eb                	jmp    b5e <memmove+0x14>
  return vdst;
}
 b73:	5b                   	pop    %ebx
 b74:	5e                   	pop    %esi
 b75:	5d                   	pop    %ebp
 b76:	c3                   	ret    

00000b77 <fork>:
  name: \
    movl $SYS_ ## name, %eax; \
    int $T_SYSCALL; \
    ret

SYSCALL(fork)
 b77:	b8 01 00 00 00       	mov    $0x1,%eax
 b7c:	cd 40                	int    $0x40
 b7e:	c3                   	ret    

00000b7f <exit>:
SYSCALL(exit)
 b7f:	b8 02 00 00 00       	mov    $0x2,%eax
 b84:	cd 40                	int    $0x40
 b86:	c3                   	ret    

00000b87 <wait>:
SYSCALL(wait)
 b87:	b8 03 00 00 00       	mov    $0x3,%eax
 b8c:	cd 40                	int    $0x40
 b8e:	c3                   	ret    

00000b8f <pipe>:
SYSCALL(pipe)
 b8f:	b8 04 00 00 00       	mov    $0x4,%eax
 b94:	cd 40                	int    $0x40
 b96:	c3                   	ret    

00000b97 <read>:
SYSCALL(read)
 b97:	b8 05 00 00 00       	mov    $0x5,%eax
 b9c:	cd 40                	int    $0x40
 b9e:	c3                   	ret    

00000b9f <write>:
SYSCALL(write)
 b9f:	b8 10 00 00 00       	mov    $0x10,%eax
 ba4:	cd 40                	int    $0x40
 ba6:	c3                   	ret    

00000ba7 <close>:
SYSCALL(close)
 ba7:	b8 15 00 00 00       	mov    $0x15,%eax
 bac:	cd 40                	int    $0x40
 bae:	c3                   	ret    

00000baf <kill>:
SYSCALL(kill)
 baf:	b8 06 00 00 00       	mov    $0x6,%eax
 bb4:	cd 40                	int    $0x40
 bb6:	c3                   	ret    

00000bb7 <exec>:
SYSCALL(exec)
 bb7:	b8 07 00 00 00       	mov    $0x7,%eax
 bbc:	cd 40                	int    $0x40
 bbe:	c3                   	ret    

00000bbf <open>:
SYSCALL(open)
 bbf:	b8 0f 00 00 00       	mov    $0xf,%eax
 bc4:	cd 40                	int    $0x40
 bc6:	c3                   	ret    

00000bc7 <mknod>:
SYSCALL(mknod)
 bc7:	b8 11 00 00 00       	mov    $0x11,%eax
 bcc:	cd 40                	int    $0x40
 bce:	c3                   	ret    

00000bcf <unlink>:
SYSCALL(unlink)
 bcf:	b8 12 00 00 00       	mov    $0x12,%eax
 bd4:	cd 40                	int    $0x40
 bd6:	c3                   	ret    

00000bd7 <fstat>:
SYSCALL(fstat)
 bd7:	b8 08 00 00 00       	mov    $0x8,%eax
 bdc:	cd 40                	int    $0x40
 bde:	c3                   	ret    

00000bdf <link>:
SYSCALL(link)
 bdf:	b8 13 00 00 00       	mov    $0x13,%eax
 be4:	cd 40                	int    $0x40
 be6:	c3                   	ret    

00000be7 <mkdir>:
SYSCALL(mkdir)
 be7:	b8 14 00 00 00       	mov    $0x14,%eax
 bec:	cd 40                	int    $0x40
 bee:	c3                   	ret    

00000bef <chdir>:
SYSCALL(chdir)
 bef:	b8 09 00 00 00       	mov    $0x9,%eax
 bf4:	cd 40                	int    $0x40
 bf6:	c3                   	ret    

00000bf7 <dup>:
SYSCALL(dup)
 bf7:	b8 0a 00 00 00       	mov    $0xa,%eax
 bfc:	cd 40                	int    $0x40
 bfe:	c3                   	ret    

00000bff <getpid>:
SYSCALL(getpid)
 bff:	b8 0b 00 00 00       	mov    $0xb,%eax
 c04:	cd 40                	int    $0x40
 c06:	c3                   	ret    

00000c07 <sbrk>:
SYSCALL(sbrk)
 c07:	b8 0c 00 00 00       	mov    $0xc,%eax
 c0c:	cd 40                	int    $0x40
 c0e:	c3                   	ret    

00000c0f <sleep>:
SYSCALL(sleep)
 c0f:	b8 0d 00 00 00       	mov    $0xd,%eax
 c14:	cd 40                	int    $0x40
 c16:	c3                   	ret    

00000c17 <uptime>:
SYSCALL(uptime)
 c17:	b8 0e 00 00 00       	mov    $0xe,%eax
 c1c:	cd 40                	int    $0x40
 c1e:	c3                   	ret    

00000c1f <date>:
SYSCALL(date)
 c1f:	b8 16 00 00 00       	mov    $0x16,%eax
 c24:	cd 40                	int    $0x40
 c26:	c3                   	ret    

00000c27 <dup2>:
 c27:	b8 17 00 00 00       	mov    $0x17,%eax
 c2c:	cd 40                	int    $0x40
 c2e:	c3                   	ret    

00000c2f <putc>:
#include "stat.h"
#include "user.h"

static void
putc(int fd, char c)
{
 c2f:	55                   	push   %ebp
 c30:	89 e5                	mov    %esp,%ebp
 c32:	83 ec 1c             	sub    $0x1c,%esp
 c35:	88 55 f4             	mov    %dl,-0xc(%ebp)
  write(fd, &c, 1);
 c38:	6a 01                	push   $0x1
 c3a:	8d 55 f4             	lea    -0xc(%ebp),%edx
 c3d:	52                   	push   %edx
 c3e:	50                   	push   %eax
 c3f:	e8 5b ff ff ff       	call   b9f <write>
}
 c44:	83 c4 10             	add    $0x10,%esp
 c47:	c9                   	leave  
 c48:	c3                   	ret    

00000c49 <printint>:

static void
printint(int fd, int xx, int base, int sgn)
{
 c49:	55                   	push   %ebp
 c4a:	89 e5                	mov    %esp,%ebp
 c4c:	57                   	push   %edi
 c4d:	56                   	push   %esi
 c4e:	53                   	push   %ebx
 c4f:	83 ec 2c             	sub    $0x2c,%esp
 c52:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 c55:	89 d6                	mov    %edx,%esi
  char buf[16];
  int i, neg;
  uint x;

  neg = 0;
  if(sgn && xx < 0){
 c57:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
 c5b:	74 04                	je     c61 <printint+0x18>
 c5d:	85 d2                	test   %edx,%edx
 c5f:	78 3a                	js     c9b <printint+0x52>
  neg = 0;
 c61:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
    x = -xx;
  } else {
    x = xx;
  }

  i = 0;
 c68:	bb 00 00 00 00       	mov    $0x0,%ebx
  do{
    buf[i++] = digits[x % base];
 c6d:	89 f0                	mov    %esi,%eax
 c6f:	ba 00 00 00 00       	mov    $0x0,%edx
 c74:	f7 f1                	div    %ecx
 c76:	89 df                	mov    %ebx,%edi
 c78:	43                   	inc    %ebx
 c79:	8a 92 58 10 00 00    	mov    0x1058(%edx),%dl
 c7f:	88 54 3d d8          	mov    %dl,-0x28(%ebp,%edi,1)
  }while((x /= base) != 0);
 c83:	89 f2                	mov    %esi,%edx
 c85:	89 c6                	mov    %eax,%esi
 c87:	39 d1                	cmp    %edx,%ecx
 c89:	76 e2                	jbe    c6d <printint+0x24>
  if(neg)
 c8b:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
 c8f:	74 22                	je     cb3 <printint+0x6a>
    buf[i++] = '-';
 c91:	c6 44 1d d8 2d       	movb   $0x2d,-0x28(%ebp,%ebx,1)
 c96:	8d 5f 02             	lea    0x2(%edi),%ebx
 c99:	eb 18                	jmp    cb3 <printint+0x6a>
    x = -xx;
 c9b:	f7 de                	neg    %esi
    neg = 1;
 c9d:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
    x = -xx;
 ca4:	eb c2                	jmp    c68 <printint+0x1f>

  while(--i >= 0)
    putc(fd, buf[i]);
 ca6:	0f be 54 1d d8       	movsbl -0x28(%ebp,%ebx,1),%edx
 cab:	8b 45 d4             	mov    -0x2c(%ebp),%eax
 cae:	e8 7c ff ff ff       	call   c2f <putc>
  while(--i >= 0)
 cb3:	4b                   	dec    %ebx
 cb4:	79 f0                	jns    ca6 <printint+0x5d>
}
 cb6:	83 c4 2c             	add    $0x2c,%esp
 cb9:	5b                   	pop    %ebx
 cba:	5e                   	pop    %esi
 cbb:	5f                   	pop    %edi
 cbc:	5d                   	pop    %ebp
 cbd:	c3                   	ret    

00000cbe <printf>:

// Print to the given fd. Only understands %d, %x, %p, %s.
void
printf(int fd, const char *fmt, ...)
{
 cbe:	f3 0f 1e fb          	endbr32 
 cc2:	55                   	push   %ebp
 cc3:	89 e5                	mov    %esp,%ebp
 cc5:	57                   	push   %edi
 cc6:	56                   	push   %esi
 cc7:	53                   	push   %ebx
 cc8:	83 ec 1c             	sub    $0x1c,%esp
  char *s;
  int c, i, state;
  uint *ap;

  state = 0;
  ap = (uint*)(void*)&fmt + 1;
 ccb:	8d 45 10             	lea    0x10(%ebp),%eax
 cce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  state = 0;
 cd1:	be 00 00 00 00       	mov    $0x0,%esi
  for(i = 0; fmt[i]; i++){
 cd6:	bb 00 00 00 00       	mov    $0x0,%ebx
 cdb:	eb 12                	jmp    cef <printf+0x31>
    c = fmt[i] & 0xff;
    if(state == 0){
      if(c == '%'){
        state = '%';
      } else {
        putc(fd, c);
 cdd:	89 fa                	mov    %edi,%edx
 cdf:	8b 45 08             	mov    0x8(%ebp),%eax
 ce2:	e8 48 ff ff ff       	call   c2f <putc>
 ce7:	eb 05                	jmp    cee <printf+0x30>
      }
    } else if(state == '%'){
 ce9:	83 fe 25             	cmp    $0x25,%esi
 cec:	74 22                	je     d10 <printf+0x52>
  for(i = 0; fmt[i]; i++){
 cee:	43                   	inc    %ebx
 cef:	8b 45 0c             	mov    0xc(%ebp),%eax
 cf2:	8a 04 18             	mov    (%eax,%ebx,1),%al
 cf5:	84 c0                	test   %al,%al
 cf7:	0f 84 13 01 00 00    	je     e10 <printf+0x152>
    c = fmt[i] & 0xff;
 cfd:	0f be f8             	movsbl %al,%edi
 d00:	0f b6 c0             	movzbl %al,%eax
    if(state == 0){
 d03:	85 f6                	test   %esi,%esi
 d05:	75 e2                	jne    ce9 <printf+0x2b>
      if(c == '%'){
 d07:	83 f8 25             	cmp    $0x25,%eax
 d0a:	75 d1                	jne    cdd <printf+0x1f>
        state = '%';
 d0c:	89 c6                	mov    %eax,%esi
 d0e:	eb de                	jmp    cee <printf+0x30>
      if(c == 'd'){
 d10:	83 f8 64             	cmp    $0x64,%eax
 d13:	74 43                	je     d58 <printf+0x9a>
        printint(fd, *ap, 10, 1);
        ap++;
      } else if(c == 'x' || c == 'p'){
 d15:	83 f8 78             	cmp    $0x78,%eax
 d18:	74 68                	je     d82 <printf+0xc4>
 d1a:	83 f8 70             	cmp    $0x70,%eax
 d1d:	74 63                	je     d82 <printf+0xc4>
        printint(fd, *ap, 16, 0);
        ap++;
      } else if(c == 's'){
 d1f:	83 f8 73             	cmp    $0x73,%eax
 d22:	0f 84 84 00 00 00    	je     dac <printf+0xee>
          s = "(null)";
        while(*s != 0){
          putc(fd, *s);
          s++;
        }
      } else if(c == 'c'){
 d28:	83 f8 63             	cmp    $0x63,%eax
 d2b:	0f 84 ad 00 00 00    	je     dde <printf+0x120>
        putc(fd, *ap);
        ap++;
      } else if(c == '%'){
 d31:	83 f8 25             	cmp    $0x25,%eax
 d34:	0f 84 c2 00 00 00    	je     dfc <printf+0x13e>
        putc(fd, c);
      } else {
        // Unknown % sequence.  Print it to draw attention.
        putc(fd, '%');
 d3a:	ba 25 00 00 00       	mov    $0x25,%edx
 d3f:	8b 45 08             	mov    0x8(%ebp),%eax
 d42:	e8 e8 fe ff ff       	call   c2f <putc>
        putc(fd, c);
 d47:	89 fa                	mov    %edi,%edx
 d49:	8b 45 08             	mov    0x8(%ebp),%eax
 d4c:	e8 de fe ff ff       	call   c2f <putc>
      }
      state = 0;
 d51:	be 00 00 00 00       	mov    $0x0,%esi
 d56:	eb 96                	jmp    cee <printf+0x30>
        printint(fd, *ap, 10, 1);
 d58:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 d5b:	8b 17                	mov    (%edi),%edx
 d5d:	83 ec 0c             	sub    $0xc,%esp
 d60:	6a 01                	push   $0x1
 d62:	b9 0a 00 00 00       	mov    $0xa,%ecx
 d67:	8b 45 08             	mov    0x8(%ebp),%eax
 d6a:	e8 da fe ff ff       	call   c49 <printint>
        ap++;
 d6f:	83 c7 04             	add    $0x4,%edi
 d72:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 d75:	83 c4 10             	add    $0x10,%esp
      state = 0;
 d78:	be 00 00 00 00       	mov    $0x0,%esi
 d7d:	e9 6c ff ff ff       	jmp    cee <printf+0x30>
        printint(fd, *ap, 16, 0);
 d82:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 d85:	8b 17                	mov    (%edi),%edx
 d87:	83 ec 0c             	sub    $0xc,%esp
 d8a:	6a 00                	push   $0x0
 d8c:	b9 10 00 00 00       	mov    $0x10,%ecx
 d91:	8b 45 08             	mov    0x8(%ebp),%eax
 d94:	e8 b0 fe ff ff       	call   c49 <printint>
        ap++;
 d99:	83 c7 04             	add    $0x4,%edi
 d9c:	89 7d e4             	mov    %edi,-0x1c(%ebp)
 d9f:	83 c4 10             	add    $0x10,%esp
      state = 0;
 da2:	be 00 00 00 00       	mov    $0x0,%esi
        ap++;
 da7:	e9 42 ff ff ff       	jmp    cee <printf+0x30>
        s = (char*)*ap;
 dac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
 daf:	8b 30                	mov    (%eax),%esi
        ap++;
 db1:	83 c0 04             	add    $0x4,%eax
 db4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        if(s == 0)
 db7:	85 f6                	test   %esi,%esi
 db9:	75 13                	jne    dce <printf+0x110>
          s = "(null)";
 dbb:	be 50 10 00 00       	mov    $0x1050,%esi
 dc0:	eb 0c                	jmp    dce <printf+0x110>
          putc(fd, *s);
 dc2:	0f be d2             	movsbl %dl,%edx
 dc5:	8b 45 08             	mov    0x8(%ebp),%eax
 dc8:	e8 62 fe ff ff       	call   c2f <putc>
          s++;
 dcd:	46                   	inc    %esi
        while(*s != 0){
 dce:	8a 16                	mov    (%esi),%dl
 dd0:	84 d2                	test   %dl,%dl
 dd2:	75 ee                	jne    dc2 <printf+0x104>
      state = 0;
 dd4:	be 00 00 00 00       	mov    $0x0,%esi
 dd9:	e9 10 ff ff ff       	jmp    cee <printf+0x30>
        putc(fd, *ap);
 dde:	8b 7d e4             	mov    -0x1c(%ebp),%edi
 de1:	0f be 17             	movsbl (%edi),%edx
 de4:	8b 45 08             	mov    0x8(%ebp),%eax
 de7:	e8 43 fe ff ff       	call   c2f <putc>
        ap++;
 dec:	83 c7 04             	add    $0x4,%edi
 def:	89 7d e4             	mov    %edi,-0x1c(%ebp)
      state = 0;
 df2:	be 00 00 00 00       	mov    $0x0,%esi
 df7:	e9 f2 fe ff ff       	jmp    cee <printf+0x30>
        putc(fd, c);
 dfc:	89 fa                	mov    %edi,%edx
 dfe:	8b 45 08             	mov    0x8(%ebp),%eax
 e01:	e8 29 fe ff ff       	call   c2f <putc>
      state = 0;
 e06:	be 00 00 00 00       	mov    $0x0,%esi
 e0b:	e9 de fe ff ff       	jmp    cee <printf+0x30>
    }
  }
}
 e10:	8d 65 f4             	lea    -0xc(%ebp),%esp
 e13:	5b                   	pop    %ebx
 e14:	5e                   	pop    %esi
 e15:	5f                   	pop    %edi
 e16:	5d                   	pop    %ebp
 e17:	c3                   	ret    

00000e18 <free>:
static Header base;
static Header *freep;

void
free(void *ap)
{
 e18:	f3 0f 1e fb          	endbr32 
 e1c:	55                   	push   %ebp
 e1d:	89 e5                	mov    %esp,%ebp
 e1f:	57                   	push   %edi
 e20:	56                   	push   %esi
 e21:	53                   	push   %ebx
 e22:	8b 5d 08             	mov    0x8(%ebp),%ebx
  Header *bp, *p;

  bp = (Header*)ap - 1;
 e25:	8d 4b f8             	lea    -0x8(%ebx),%ecx
  for(p = freep; !(bp > p && bp < p->s.ptr); p = p->s.ptr)
 e28:	a1 64 16 00 00       	mov    0x1664,%eax
 e2d:	eb 02                	jmp    e31 <free+0x19>
 e2f:	89 d0                	mov    %edx,%eax
 e31:	39 c8                	cmp    %ecx,%eax
 e33:	73 04                	jae    e39 <free+0x21>
 e35:	39 08                	cmp    %ecx,(%eax)
 e37:	77 12                	ja     e4b <free+0x33>
    if(p >= p->s.ptr && (bp > p || bp < p->s.ptr))
 e39:	8b 10                	mov    (%eax),%edx
 e3b:	39 c2                	cmp    %eax,%edx
 e3d:	77 f0                	ja     e2f <free+0x17>
 e3f:	39 c8                	cmp    %ecx,%eax
 e41:	72 08                	jb     e4b <free+0x33>
 e43:	39 ca                	cmp    %ecx,%edx
 e45:	77 04                	ja     e4b <free+0x33>
 e47:	89 d0                	mov    %edx,%eax
 e49:	eb e6                	jmp    e31 <free+0x19>
      break;
  if(bp + bp->s.size == p->s.ptr){
 e4b:	8b 73 fc             	mov    -0x4(%ebx),%esi
 e4e:	8d 3c f1             	lea    (%ecx,%esi,8),%edi
 e51:	8b 10                	mov    (%eax),%edx
 e53:	39 d7                	cmp    %edx,%edi
 e55:	74 19                	je     e70 <free+0x58>
    bp->s.size += p->s.ptr->s.size;
    bp->s.ptr = p->s.ptr->s.ptr;
  } else
    bp->s.ptr = p->s.ptr;
 e57:	89 53 f8             	mov    %edx,-0x8(%ebx)
  if(p + p->s.size == bp){
 e5a:	8b 50 04             	mov    0x4(%eax),%edx
 e5d:	8d 34 d0             	lea    (%eax,%edx,8),%esi
 e60:	39 ce                	cmp    %ecx,%esi
 e62:	74 1b                	je     e7f <free+0x67>
    p->s.size += bp->s.size;
    p->s.ptr = bp->s.ptr;
  } else
    p->s.ptr = bp;
 e64:	89 08                	mov    %ecx,(%eax)
  freep = p;
 e66:	a3 64 16 00 00       	mov    %eax,0x1664
}
 e6b:	5b                   	pop    %ebx
 e6c:	5e                   	pop    %esi
 e6d:	5f                   	pop    %edi
 e6e:	5d                   	pop    %ebp
 e6f:	c3                   	ret    
    bp->s.size += p->s.ptr->s.size;
 e70:	03 72 04             	add    0x4(%edx),%esi
 e73:	89 73 fc             	mov    %esi,-0x4(%ebx)
    bp->s.ptr = p->s.ptr->s.ptr;
 e76:	8b 10                	mov    (%eax),%edx
 e78:	8b 12                	mov    (%edx),%edx
 e7a:	89 53 f8             	mov    %edx,-0x8(%ebx)
 e7d:	eb db                	jmp    e5a <free+0x42>
    p->s.size += bp->s.size;
 e7f:	03 53 fc             	add    -0x4(%ebx),%edx
 e82:	89 50 04             	mov    %edx,0x4(%eax)
    p->s.ptr = bp->s.ptr;
 e85:	8b 53 f8             	mov    -0x8(%ebx),%edx
 e88:	89 10                	mov    %edx,(%eax)
 e8a:	eb da                	jmp    e66 <free+0x4e>

00000e8c <morecore>:

static Header*
morecore(uint nu)
{
 e8c:	55                   	push   %ebp
 e8d:	89 e5                	mov    %esp,%ebp
 e8f:	53                   	push   %ebx
 e90:	83 ec 04             	sub    $0x4,%esp
 e93:	89 c3                	mov    %eax,%ebx
  char *p;
  Header *hp;

  if(nu < 4096)
 e95:	3d ff 0f 00 00       	cmp    $0xfff,%eax
 e9a:	77 05                	ja     ea1 <morecore+0x15>
    nu = 4096;
 e9c:	bb 00 10 00 00       	mov    $0x1000,%ebx
  p = sbrk(nu * sizeof(Header));
 ea1:	8d 04 dd 00 00 00 00 	lea    0x0(,%ebx,8),%eax
 ea8:	83 ec 0c             	sub    $0xc,%esp
 eab:	50                   	push   %eax
 eac:	e8 56 fd ff ff       	call   c07 <sbrk>
  if(p == (char*)-1)
 eb1:	83 c4 10             	add    $0x10,%esp
 eb4:	83 f8 ff             	cmp    $0xffffffff,%eax
 eb7:	74 1c                	je     ed5 <morecore+0x49>
    return 0;
  hp = (Header*)p;
  hp->s.size = nu;
 eb9:	89 58 04             	mov    %ebx,0x4(%eax)
  free((void*)(hp + 1));
 ebc:	83 c0 08             	add    $0x8,%eax
 ebf:	83 ec 0c             	sub    $0xc,%esp
 ec2:	50                   	push   %eax
 ec3:	e8 50 ff ff ff       	call   e18 <free>
  return freep;
 ec8:	a1 64 16 00 00       	mov    0x1664,%eax
 ecd:	83 c4 10             	add    $0x10,%esp
}
 ed0:	8b 5d fc             	mov    -0x4(%ebp),%ebx
 ed3:	c9                   	leave  
 ed4:	c3                   	ret    
    return 0;
 ed5:	b8 00 00 00 00       	mov    $0x0,%eax
 eda:	eb f4                	jmp    ed0 <morecore+0x44>

00000edc <malloc>:

void*
malloc(uint nbytes)
{
 edc:	f3 0f 1e fb          	endbr32 
 ee0:	55                   	push   %ebp
 ee1:	89 e5                	mov    %esp,%ebp
 ee3:	53                   	push   %ebx
 ee4:	83 ec 04             	sub    $0x4,%esp
  Header *p, *prevp;
  uint nunits;

  nunits = (nbytes + sizeof(Header) - 1)/sizeof(Header) + 1;
 ee7:	8b 45 08             	mov    0x8(%ebp),%eax
 eea:	8d 58 07             	lea    0x7(%eax),%ebx
 eed:	c1 eb 03             	shr    $0x3,%ebx
 ef0:	43                   	inc    %ebx
  if((prevp = freep) == 0){
 ef1:	8b 0d 64 16 00 00    	mov    0x1664,%ecx
 ef7:	85 c9                	test   %ecx,%ecx
 ef9:	74 04                	je     eff <malloc+0x23>
    base.s.ptr = freep = prevp = &base;
    base.s.size = 0;
  }
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 efb:	8b 01                	mov    (%ecx),%eax
 efd:	eb 4b                	jmp    f4a <malloc+0x6e>
    base.s.ptr = freep = prevp = &base;
 eff:	c7 05 64 16 00 00 68 	movl   $0x1668,0x1664
 f06:	16 00 00 
 f09:	c7 05 68 16 00 00 68 	movl   $0x1668,0x1668
 f10:	16 00 00 
    base.s.size = 0;
 f13:	c7 05 6c 16 00 00 00 	movl   $0x0,0x166c
 f1a:	00 00 00 
    base.s.ptr = freep = prevp = &base;
 f1d:	b9 68 16 00 00       	mov    $0x1668,%ecx
 f22:	eb d7                	jmp    efb <malloc+0x1f>
    if(p->s.size >= nunits){
      if(p->s.size == nunits)
 f24:	74 1a                	je     f40 <malloc+0x64>
        prevp->s.ptr = p->s.ptr;
      else {
        p->s.size -= nunits;
 f26:	29 da                	sub    %ebx,%edx
 f28:	89 50 04             	mov    %edx,0x4(%eax)
        p += p->s.size;
 f2b:	8d 04 d0             	lea    (%eax,%edx,8),%eax
        p->s.size = nunits;
 f2e:	89 58 04             	mov    %ebx,0x4(%eax)
      }
      freep = prevp;
 f31:	89 0d 64 16 00 00    	mov    %ecx,0x1664
      return (void*)(p + 1);
 f37:	83 c0 08             	add    $0x8,%eax
    }
    if(p == freep)
      if((p = morecore(nunits)) == 0)
        return 0;
  }
}
 f3a:	83 c4 04             	add    $0x4,%esp
 f3d:	5b                   	pop    %ebx
 f3e:	5d                   	pop    %ebp
 f3f:	c3                   	ret    
        prevp->s.ptr = p->s.ptr;
 f40:	8b 10                	mov    (%eax),%edx
 f42:	89 11                	mov    %edx,(%ecx)
 f44:	eb eb                	jmp    f31 <malloc+0x55>
  for(p = prevp->s.ptr; ; prevp = p, p = p->s.ptr){
 f46:	89 c1                	mov    %eax,%ecx
 f48:	8b 00                	mov    (%eax),%eax
    if(p->s.size >= nunits){
 f4a:	8b 50 04             	mov    0x4(%eax),%edx
 f4d:	39 da                	cmp    %ebx,%edx
 f4f:	73 d3                	jae    f24 <malloc+0x48>
    if(p == freep)
 f51:	39 05 64 16 00 00    	cmp    %eax,0x1664
 f57:	75 ed                	jne    f46 <malloc+0x6a>
      if((p = morecore(nunits)) == 0)
 f59:	89 d8                	mov    %ebx,%eax
 f5b:	e8 2c ff ff ff       	call   e8c <morecore>
 f60:	85 c0                	test   %eax,%eax
 f62:	75 e2                	jne    f46 <malloc+0x6a>
 f64:	eb d4                	jmp    f3a <malloc+0x5e>
