
kernel/system:     file format elf32-i386


Disassembly of section .text:

f0100000 <strlen>:
// Primespipe runs 3x faster this way.
#define ASM 1

int
strlen(const char *s)
{
f0100000:	8b 54 24 04          	mov    0x4(%esp),%edx
	int n;

	for (n = 0; *s != '\0'; s++)
f0100004:	b8 00 00 00 00       	mov    $0x0,%eax
f0100009:	80 3a 00             	cmpb   $0x0,(%edx)
f010000c:	74 09                	je     f0100017 <strlen+0x17>
		n++;
f010000e:	83 c0 01             	add    $0x1,%eax
int
strlen(const char *s)
{
	int n;

	for (n = 0; *s != '\0'; s++)
f0100011:	80 3c 02 00          	cmpb   $0x0,(%edx,%eax,1)
f0100015:	75 f7                	jne    f010000e <strlen+0xe>
		n++;
	return n;
}
f0100017:	f3 c3                	repz ret 

f0100019 <strnlen>:

int
strnlen(const char *s, size_t size)
{
f0100019:	8b 4c 24 04          	mov    0x4(%esp),%ecx
f010001d:	8b 54 24 08          	mov    0x8(%esp),%edx
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0100021:	b8 00 00 00 00       	mov    $0x0,%eax
f0100026:	85 d2                	test   %edx,%edx
f0100028:	74 12                	je     f010003c <strnlen+0x23>
f010002a:	80 39 00             	cmpb   $0x0,(%ecx)
f010002d:	74 0d                	je     f010003c <strnlen+0x23>
		n++;
f010002f:	83 c0 01             	add    $0x1,%eax
int
strnlen(const char *s, size_t size)
{
	int n;

	for (n = 0; size > 0 && *s != '\0'; s++, size--)
f0100032:	39 d0                	cmp    %edx,%eax
f0100034:	74 06                	je     f010003c <strnlen+0x23>
f0100036:	80 3c 01 00          	cmpb   $0x0,(%ecx,%eax,1)
f010003a:	75 f3                	jne    f010002f <strnlen+0x16>
		n++;
	return n;
}
f010003c:	f3 c3                	repz ret 

f010003e <strcpy>:

char *
strcpy(char *dst, const char *src)
{
f010003e:	53                   	push   %ebx
f010003f:	8b 44 24 08          	mov    0x8(%esp),%eax
f0100043:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
	char *ret;

	ret = dst;
	while ((*dst++ = *src++) != '\0')
f0100047:	ba 00 00 00 00       	mov    $0x0,%edx
f010004c:	0f b6 0c 13          	movzbl (%ebx,%edx,1),%ecx
f0100050:	88 0c 10             	mov    %cl,(%eax,%edx,1)
f0100053:	83 c2 01             	add    $0x1,%edx
f0100056:	84 c9                	test   %cl,%cl
f0100058:	75 f2                	jne    f010004c <strcpy+0xe>
		/* do nothing */;
	return ret;
}
f010005a:	5b                   	pop    %ebx
f010005b:	c3                   	ret    

f010005c <strcat>:

char *
strcat(char *dst, const char *src)
{
f010005c:	53                   	push   %ebx
f010005d:	83 ec 08             	sub    $0x8,%esp
f0100060:	8b 5c 24 10          	mov    0x10(%esp),%ebx
	int len = strlen(dst);
f0100064:	89 1c 24             	mov    %ebx,(%esp)
f0100067:	e8 94 ff ff ff       	call   f0100000 <strlen>
	strcpy(dst + len, src);
f010006c:	8b 54 24 14          	mov    0x14(%esp),%edx
f0100070:	89 54 24 04          	mov    %edx,0x4(%esp)
f0100074:	8d 04 03             	lea    (%ebx,%eax,1),%eax
f0100077:	89 04 24             	mov    %eax,(%esp)
f010007a:	e8 bf ff ff ff       	call   f010003e <strcpy>
	return dst;
}
f010007f:	89 d8                	mov    %ebx,%eax
f0100081:	83 c4 08             	add    $0x8,%esp
f0100084:	5b                   	pop    %ebx
f0100085:	c3                   	ret    

f0100086 <strncpy>:

char *
strncpy(char *dst, const char *src, size_t size) {
f0100086:	56                   	push   %esi
f0100087:	53                   	push   %ebx
f0100088:	8b 44 24 0c          	mov    0xc(%esp),%eax
f010008c:	8b 54 24 10          	mov    0x10(%esp),%edx
f0100090:	8b 74 24 14          	mov    0x14(%esp),%esi
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f0100094:	85 f6                	test   %esi,%esi
f0100096:	74 18                	je     f01000b0 <strncpy+0x2a>
f0100098:	b9 00 00 00 00       	mov    $0x0,%ecx
		*dst++ = *src;
f010009d:	0f b6 1a             	movzbl (%edx),%ebx
f01000a0:	88 1c 08             	mov    %bl,(%eax,%ecx,1)
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
f01000a3:	80 3a 01             	cmpb   $0x1,(%edx)
f01000a6:	83 da ff             	sbb    $0xffffffff,%edx
strncpy(char *dst, const char *src, size_t size) {
	size_t i;
	char *ret;

	ret = dst;
	for (i = 0; i < size; i++) {
f01000a9:	83 c1 01             	add    $0x1,%ecx
f01000ac:	39 ce                	cmp    %ecx,%esi
f01000ae:	77 ed                	ja     f010009d <strncpy+0x17>
		// If strlen(src) < size, null-pad 'dst' out to 'size' chars
		if (*src != '\0')
			src++;
	}
	return ret;
}
f01000b0:	5b                   	pop    %ebx
f01000b1:	5e                   	pop    %esi
f01000b2:	c3                   	ret    

f01000b3 <strlcpy>:

size_t
strlcpy(char *dst, const char *src, size_t size)
{
f01000b3:	57                   	push   %edi
f01000b4:	56                   	push   %esi
f01000b5:	53                   	push   %ebx
f01000b6:	8b 7c 24 10          	mov    0x10(%esp),%edi
f01000ba:	8b 5c 24 14          	mov    0x14(%esp),%ebx
f01000be:	8b 74 24 18          	mov    0x18(%esp),%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
f01000c2:	89 f8                	mov    %edi,%eax
f01000c4:	85 f6                	test   %esi,%esi
f01000c6:	74 2c                	je     f01000f4 <strlcpy+0x41>
		while (--size > 0 && *src != '\0')
f01000c8:	83 fe 01             	cmp    $0x1,%esi
f01000cb:	74 24                	je     f01000f1 <strlcpy+0x3e>
f01000cd:	0f b6 0b             	movzbl (%ebx),%ecx
f01000d0:	84 c9                	test   %cl,%cl
f01000d2:	74 1d                	je     f01000f1 <strlcpy+0x3e>
f01000d4:	ba 00 00 00 00       	mov    $0x0,%edx
	}
	return ret;
}

size_t
strlcpy(char *dst, const char *src, size_t size)
f01000d9:	83 ee 02             	sub    $0x2,%esi
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
			*dst++ = *src++;
f01000dc:	88 08                	mov    %cl,(%eax)
f01000de:	83 c0 01             	add    $0x1,%eax
{
	char *dst_in;

	dst_in = dst;
	if (size > 0) {
		while (--size > 0 && *src != '\0')
f01000e1:	39 f2                	cmp    %esi,%edx
f01000e3:	74 0c                	je     f01000f1 <strlcpy+0x3e>
f01000e5:	0f b6 4c 13 01       	movzbl 0x1(%ebx,%edx,1),%ecx
f01000ea:	83 c2 01             	add    $0x1,%edx
f01000ed:	84 c9                	test   %cl,%cl
f01000ef:	75 eb                	jne    f01000dc <strlcpy+0x29>
			*dst++ = *src++;
		*dst = '\0';
f01000f1:	c6 00 00             	movb   $0x0,(%eax)
	}
	return dst - dst_in;
f01000f4:	29 f8                	sub    %edi,%eax
}
f01000f6:	5b                   	pop    %ebx
f01000f7:	5e                   	pop    %esi
f01000f8:	5f                   	pop    %edi
f01000f9:	c3                   	ret    

f01000fa <strcmp>:

int
strcmp(const char *p, const char *q)
{
f01000fa:	8b 4c 24 04          	mov    0x4(%esp),%ecx
f01000fe:	8b 54 24 08          	mov    0x8(%esp),%edx
	while (*p && *p == *q)
f0100102:	0f b6 01             	movzbl (%ecx),%eax
f0100105:	84 c0                	test   %al,%al
f0100107:	74 15                	je     f010011e <strcmp+0x24>
f0100109:	3a 02                	cmp    (%edx),%al
f010010b:	75 11                	jne    f010011e <strcmp+0x24>
		p++, q++;
f010010d:	83 c1 01             	add    $0x1,%ecx
f0100110:	83 c2 01             	add    $0x1,%edx
}

int
strcmp(const char *p, const char *q)
{
	while (*p && *p == *q)
f0100113:	0f b6 01             	movzbl (%ecx),%eax
f0100116:	84 c0                	test   %al,%al
f0100118:	74 04                	je     f010011e <strcmp+0x24>
f010011a:	3a 02                	cmp    (%edx),%al
f010011c:	74 ef                	je     f010010d <strcmp+0x13>
		p++, q++;
	return (int) ((unsigned char) *p - (unsigned char) *q);
f010011e:	0f b6 c0             	movzbl %al,%eax
f0100121:	0f b6 12             	movzbl (%edx),%edx
f0100124:	29 d0                	sub    %edx,%eax
}
f0100126:	c3                   	ret    

f0100127 <strncmp>:

int
strncmp(const char *p, const char *q, size_t n)
{
f0100127:	53                   	push   %ebx
f0100128:	8b 4c 24 08          	mov    0x8(%esp),%ecx
f010012c:	8b 5c 24 0c          	mov    0xc(%esp),%ebx
f0100130:	8b 54 24 10          	mov    0x10(%esp),%edx
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
f0100134:	b8 00 00 00 00       	mov    $0x0,%eax
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
f0100139:	85 d2                	test   %edx,%edx
f010013b:	74 28                	je     f0100165 <strncmp+0x3e>
f010013d:	0f b6 01             	movzbl (%ecx),%eax
f0100140:	84 c0                	test   %al,%al
f0100142:	74 23                	je     f0100167 <strncmp+0x40>
f0100144:	3a 03                	cmp    (%ebx),%al
f0100146:	75 1f                	jne    f0100167 <strncmp+0x40>
f0100148:	83 ea 01             	sub    $0x1,%edx
f010014b:	74 13                	je     f0100160 <strncmp+0x39>
		n--, p++, q++;
f010014d:	83 c1 01             	add    $0x1,%ecx
f0100150:	83 c3 01             	add    $0x1,%ebx
}

int
strncmp(const char *p, const char *q, size_t n)
{
	while (n > 0 && *p && *p == *q)
f0100153:	0f b6 01             	movzbl (%ecx),%eax
f0100156:	84 c0                	test   %al,%al
f0100158:	74 0d                	je     f0100167 <strncmp+0x40>
f010015a:	3a 03                	cmp    (%ebx),%al
f010015c:	74 ea                	je     f0100148 <strncmp+0x21>
f010015e:	eb 07                	jmp    f0100167 <strncmp+0x40>
		n--, p++, q++;
	if (n == 0)
		return 0;
f0100160:	b8 00 00 00 00       	mov    $0x0,%eax
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
}
f0100165:	5b                   	pop    %ebx
f0100166:	c3                   	ret    
	while (n > 0 && *p && *p == *q)
		n--, p++, q++;
	if (n == 0)
		return 0;
	else
		return (int) ((unsigned char) *p - (unsigned char) *q);
f0100167:	0f b6 01             	movzbl (%ecx),%eax
f010016a:	0f b6 13             	movzbl (%ebx),%edx
f010016d:	29 d0                	sub    %edx,%eax
f010016f:	eb f4                	jmp    f0100165 <strncmp+0x3e>

f0100171 <strchr>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
f0100171:	8b 44 24 04          	mov    0x4(%esp),%eax
f0100175:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
	for (; *s; s++)
f010017a:	0f b6 10             	movzbl (%eax),%edx
f010017d:	84 d2                	test   %dl,%dl
f010017f:	74 21                	je     f01001a2 <strchr+0x31>
		if (*s == c)
f0100181:	38 ca                	cmp    %cl,%dl
f0100183:	75 0d                	jne    f0100192 <strchr+0x21>
f0100185:	f3 c3                	repz ret 
f0100187:	38 ca                	cmp    %cl,%dl
f0100189:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
f0100190:	74 15                	je     f01001a7 <strchr+0x36>
// Return a pointer to the first occurrence of 'c' in 's',
// or a null pointer if the string has no 'c'.
char *
strchr(const char *s, char c)
{
	for (; *s; s++)
f0100192:	83 c0 01             	add    $0x1,%eax
f0100195:	0f b6 10             	movzbl (%eax),%edx
f0100198:	84 d2                	test   %dl,%dl
f010019a:	75 eb                	jne    f0100187 <strchr+0x16>
		if (*s == c)
			return (char *) s;
	return 0;
f010019c:	b8 00 00 00 00       	mov    $0x0,%eax
f01001a1:	c3                   	ret    
f01001a2:	b8 00 00 00 00       	mov    $0x0,%eax
}
f01001a7:	f3 c3                	repz ret 

f01001a9 <strfind>:

// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
f01001a9:	8b 44 24 04          	mov    0x4(%esp),%eax
f01001ad:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
	for (; *s; s++)
f01001b2:	0f b6 10             	movzbl (%eax),%edx
f01001b5:	84 d2                	test   %dl,%dl
f01001b7:	74 14                	je     f01001cd <strfind+0x24>
		if (*s == c)
f01001b9:	38 ca                	cmp    %cl,%dl
f01001bb:	75 06                	jne    f01001c3 <strfind+0x1a>
f01001bd:	f3 c3                	repz ret 
f01001bf:	38 ca                	cmp    %cl,%dl
f01001c1:	74 0a                	je     f01001cd <strfind+0x24>
// Return a pointer to the first occurrence of 'c' in 's',
// or a pointer to the string-ending null character if the string has no 'c'.
char *
strfind(const char *s, char c)
{
	for (; *s; s++)
f01001c3:	83 c0 01             	add    $0x1,%eax
f01001c6:	0f b6 10             	movzbl (%eax),%edx
f01001c9:	84 d2                	test   %dl,%dl
f01001cb:	75 f2                	jne    f01001bf <strfind+0x16>
		if (*s == c)
			break;
	return (char *) s;
}
f01001cd:	f3 c3                	repz ret 

f01001cf <memset>:

#if ASM
void *
memset(void *v, int c, size_t n)
{
f01001cf:	83 ec 0c             	sub    $0xc,%esp
f01001d2:	89 1c 24             	mov    %ebx,(%esp)
f01001d5:	89 74 24 04          	mov    %esi,0x4(%esp)
f01001d9:	89 7c 24 08          	mov    %edi,0x8(%esp)
f01001dd:	8b 7c 24 10          	mov    0x10(%esp),%edi
f01001e1:	8b 44 24 14          	mov    0x14(%esp),%eax
f01001e5:	8b 4c 24 18          	mov    0x18(%esp),%ecx
	if (n == 0)
f01001e9:	85 c9                	test   %ecx,%ecx
f01001eb:	74 30                	je     f010021d <memset+0x4e>
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
f01001ed:	f7 c7 03 00 00 00    	test   $0x3,%edi
f01001f3:	75 25                	jne    f010021a <memset+0x4b>
f01001f5:	f6 c1 03             	test   $0x3,%cl
f01001f8:	75 20                	jne    f010021a <memset+0x4b>
		c &= 0xFF;
f01001fa:	0f b6 d0             	movzbl %al,%edx
		c = (c<<24)|(c<<16)|(c<<8)|c;
f01001fd:	89 d3                	mov    %edx,%ebx
f01001ff:	c1 e3 08             	shl    $0x8,%ebx
f0100202:	89 d6                	mov    %edx,%esi
f0100204:	c1 e6 18             	shl    $0x18,%esi
f0100207:	89 d0                	mov    %edx,%eax
f0100209:	c1 e0 10             	shl    $0x10,%eax
f010020c:	09 f0                	or     %esi,%eax
f010020e:	09 d0                	or     %edx,%eax
f0100210:	09 d8                	or     %ebx,%eax
		asm volatile("cld; rep stosl\n"
			:: "D" (v), "a" (c), "c" (n/4)
f0100212:	c1 e9 02             	shr    $0x2,%ecx
	if (n == 0)
		return v;
	if ((int)v%4 == 0 && n%4 == 0) {
		c &= 0xFF;
		c = (c<<24)|(c<<16)|(c<<8)|c;
		asm volatile("cld; rep stosl\n"
f0100215:	fc                   	cld    
f0100216:	f3 ab                	rep stos %eax,%es:(%edi)
f0100218:	eb 03                	jmp    f010021d <memset+0x4e>
			:: "D" (v), "a" (c), "c" (n/4)
			: "cc", "memory");
	} else
		asm volatile("cld; rep stosb\n"
f010021a:	fc                   	cld    
f010021b:	f3 aa                	rep stos %al,%es:(%edi)
			:: "D" (v), "a" (c), "c" (n)
			: "cc", "memory");
	return v;
}
f010021d:	89 f8                	mov    %edi,%eax
f010021f:	8b 1c 24             	mov    (%esp),%ebx
f0100222:	8b 74 24 04          	mov    0x4(%esp),%esi
f0100226:	8b 7c 24 08          	mov    0x8(%esp),%edi
f010022a:	83 c4 0c             	add    $0xc,%esp
f010022d:	c3                   	ret    

f010022e <memmove>:

void *
memmove(void *dst, const void *src, size_t n)
{
f010022e:	83 ec 08             	sub    $0x8,%esp
f0100231:	89 34 24             	mov    %esi,(%esp)
f0100234:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100238:	8b 44 24 0c          	mov    0xc(%esp),%eax
f010023c:	8b 74 24 10          	mov    0x10(%esp),%esi
f0100240:	8b 4c 24 14          	mov    0x14(%esp),%ecx
	const char *s;
	char *d;

	s = src;
	d = dst;
	if (s < d && s + n > d) {
f0100244:	39 c6                	cmp    %eax,%esi
f0100246:	73 36                	jae    f010027e <memmove+0x50>
f0100248:	8d 14 0e             	lea    (%esi,%ecx,1),%edx
f010024b:	39 d0                	cmp    %edx,%eax
f010024d:	73 2f                	jae    f010027e <memmove+0x50>
		s += n;
		d += n;
f010024f:	8d 3c 08             	lea    (%eax,%ecx,1),%edi
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f0100252:	f6 c2 03             	test   $0x3,%dl
f0100255:	75 1b                	jne    f0100272 <memmove+0x44>
f0100257:	f7 c7 03 00 00 00    	test   $0x3,%edi
f010025d:	75 13                	jne    f0100272 <memmove+0x44>
f010025f:	f6 c1 03             	test   $0x3,%cl
f0100262:	75 0e                	jne    f0100272 <memmove+0x44>
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
f0100264:	83 ef 04             	sub    $0x4,%edi
f0100267:	8d 72 fc             	lea    -0x4(%edx),%esi
f010026a:	c1 e9 02             	shr    $0x2,%ecx
	d = dst;
	if (s < d && s + n > d) {
		s += n;
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
f010026d:	fd                   	std    
f010026e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0100270:	eb 09                	jmp    f010027b <memmove+0x4d>
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
f0100272:	83 ef 01             	sub    $0x1,%edi
f0100275:	8d 72 ff             	lea    -0x1(%edx),%esi
		d += n;
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("std; rep movsl\n"
				:: "D" (d-4), "S" (s-4), "c" (n/4) : "cc", "memory");
		else
			asm volatile("std; rep movsb\n"
f0100278:	fd                   	std    
f0100279:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
f010027b:	fc                   	cld    
f010027c:	eb 20                	jmp    f010029e <memmove+0x70>
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
f010027e:	f7 c6 03 00 00 00    	test   $0x3,%esi
f0100284:	75 13                	jne    f0100299 <memmove+0x6b>
f0100286:	a8 03                	test   $0x3,%al
f0100288:	75 0f                	jne    f0100299 <memmove+0x6b>
f010028a:	f6 c1 03             	test   $0x3,%cl
f010028d:	75 0a                	jne    f0100299 <memmove+0x6b>
			asm volatile("cld; rep movsl\n"
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
f010028f:	c1 e9 02             	shr    $0x2,%ecx
				:: "D" (d-1), "S" (s-1), "c" (n) : "cc", "memory");
		// Some versions of GCC rely on DF being clear
		asm volatile("cld" ::: "cc");
	} else {
		if ((int)s%4 == 0 && (int)d%4 == 0 && n%4 == 0)
			asm volatile("cld; rep movsl\n"
f0100292:	89 c7                	mov    %eax,%edi
f0100294:	fc                   	cld    
f0100295:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0100297:	eb 05                	jmp    f010029e <memmove+0x70>
				:: "D" (d), "S" (s), "c" (n/4) : "cc", "memory");
		else
			asm volatile("cld; rep movsb\n"
f0100299:	89 c7                	mov    %eax,%edi
f010029b:	fc                   	cld    
f010029c:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
				:: "D" (d), "S" (s), "c" (n) : "cc", "memory");
	}
	return dst;
}
f010029e:	8b 34 24             	mov    (%esp),%esi
f01002a1:	8b 7c 24 04          	mov    0x4(%esp),%edi
f01002a5:	83 c4 08             	add    $0x8,%esp
f01002a8:	c3                   	ret    

f01002a9 <memcpy>:
}
#endif

void *
memcpy(void *dst, const void *src, size_t n)
{
f01002a9:	83 ec 0c             	sub    $0xc,%esp
	return memmove(dst, src, n);
f01002ac:	8b 44 24 18          	mov    0x18(%esp),%eax
f01002b0:	89 44 24 08          	mov    %eax,0x8(%esp)
f01002b4:	8b 44 24 14          	mov    0x14(%esp),%eax
f01002b8:	89 44 24 04          	mov    %eax,0x4(%esp)
f01002bc:	8b 44 24 10          	mov    0x10(%esp),%eax
f01002c0:	89 04 24             	mov    %eax,(%esp)
f01002c3:	e8 66 ff ff ff       	call   f010022e <memmove>
}
f01002c8:	83 c4 0c             	add    $0xc,%esp
f01002cb:	c3                   	ret    

f01002cc <memcmp>:

int
memcmp(const void *v1, const void *v2, size_t n)
{
f01002cc:	57                   	push   %edi
f01002cd:	56                   	push   %esi
f01002ce:	53                   	push   %ebx
f01002cf:	8b 5c 24 10          	mov    0x10(%esp),%ebx
f01002d3:	8b 74 24 14          	mov    0x14(%esp),%esi
f01002d7:	8b 7c 24 18          	mov    0x18(%esp),%edi
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
f01002db:	b8 00 00 00 00       	mov    $0x0,%eax
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f01002e0:	85 ff                	test   %edi,%edi
f01002e2:	74 38                	je     f010031c <memcmp+0x50>
		if (*s1 != *s2)
f01002e4:	0f b6 03             	movzbl (%ebx),%eax
f01002e7:	0f b6 0e             	movzbl (%esi),%ecx
f01002ea:	38 c8                	cmp    %cl,%al
f01002ec:	74 1d                	je     f010030b <memcmp+0x3f>
f01002ee:	eb 11                	jmp    f0100301 <memcmp+0x35>
f01002f0:	0f b6 44 13 01       	movzbl 0x1(%ebx,%edx,1),%eax
f01002f5:	0f b6 4c 16 01       	movzbl 0x1(%esi,%edx,1),%ecx
f01002fa:	83 c2 01             	add    $0x1,%edx
f01002fd:	38 c8                	cmp    %cl,%al
f01002ff:	74 12                	je     f0100313 <memcmp+0x47>
			return (int) *s1 - (int) *s2;
f0100301:	0f b6 c0             	movzbl %al,%eax
f0100304:	0f b6 c9             	movzbl %cl,%ecx
f0100307:	29 c8                	sub    %ecx,%eax
f0100309:	eb 11                	jmp    f010031c <memcmp+0x50>
memcmp(const void *v1, const void *v2, size_t n)
{
	const uint8_t *s1 = (const uint8_t *) v1;
	const uint8_t *s2 = (const uint8_t *) v2;

	while (n-- > 0) {
f010030b:	83 ef 01             	sub    $0x1,%edi
f010030e:	ba 00 00 00 00       	mov    $0x0,%edx
f0100313:	39 fa                	cmp    %edi,%edx
f0100315:	75 d9                	jne    f01002f0 <memcmp+0x24>
		if (*s1 != *s2)
			return (int) *s1 - (int) *s2;
		s1++, s2++;
	}

	return 0;
f0100317:	b8 00 00 00 00       	mov    $0x0,%eax
}
f010031c:	5b                   	pop    %ebx
f010031d:	5e                   	pop    %esi
f010031e:	5f                   	pop    %edi
f010031f:	c3                   	ret    

f0100320 <memfind>:

void *
memfind(const void *s, int c, size_t n)
{
f0100320:	8b 44 24 04          	mov    0x4(%esp),%eax
	const void *ends = (const char *) s + n;
f0100324:	89 c2                	mov    %eax,%edx
f0100326:	03 54 24 0c          	add    0xc(%esp),%edx
	for (; s < ends; s++)
f010032a:	39 d0                	cmp    %edx,%eax
f010032c:	73 16                	jae    f0100344 <memfind+0x24>
		if (*(const unsigned char *) s == (unsigned char) c)
f010032e:	0f b6 4c 24 08       	movzbl 0x8(%esp),%ecx
f0100333:	38 08                	cmp    %cl,(%eax)
f0100335:	75 06                	jne    f010033d <memfind+0x1d>
f0100337:	f3 c3                	repz ret 
f0100339:	38 08                	cmp    %cl,(%eax)
f010033b:	74 07                	je     f0100344 <memfind+0x24>

void *
memfind(const void *s, int c, size_t n)
{
	const void *ends = (const char *) s + n;
	for (; s < ends; s++)
f010033d:	83 c0 01             	add    $0x1,%eax
f0100340:	39 c2                	cmp    %eax,%edx
f0100342:	77 f5                	ja     f0100339 <memfind+0x19>
		if (*(const unsigned char *) s == (unsigned char) c)
			break;
	return (void *) s;
}
f0100344:	f3 c3                	repz ret 

f0100346 <strtol>:

long
strtol(const char *s, char **endptr, int base)
{
f0100346:	55                   	push   %ebp
f0100347:	57                   	push   %edi
f0100348:	56                   	push   %esi
f0100349:	53                   	push   %ebx
f010034a:	8b 54 24 14          	mov    0x14(%esp),%edx
f010034e:	8b 74 24 18          	mov    0x18(%esp),%esi
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0100352:	0f b6 02             	movzbl (%edx),%eax
f0100355:	3c 20                	cmp    $0x20,%al
f0100357:	74 04                	je     f010035d <strtol+0x17>
f0100359:	3c 09                	cmp    $0x9,%al
f010035b:	75 0e                	jne    f010036b <strtol+0x25>
		s++;
f010035d:	83 c2 01             	add    $0x1,%edx
{
	int neg = 0;
	long val = 0;

	// gobble initial whitespace
	while (*s == ' ' || *s == '\t')
f0100360:	0f b6 02             	movzbl (%edx),%eax
f0100363:	3c 20                	cmp    $0x20,%al
f0100365:	74 f6                	je     f010035d <strtol+0x17>
f0100367:	3c 09                	cmp    $0x9,%al
f0100369:	74 f2                	je     f010035d <strtol+0x17>
		s++;

	// plus/minus sign
	if (*s == '+')
f010036b:	3c 2b                	cmp    $0x2b,%al
f010036d:	75 0a                	jne    f0100379 <strtol+0x33>
		s++;
f010036f:	83 c2 01             	add    $0x1,%edx
}

long
strtol(const char *s, char **endptr, int base)
{
	int neg = 0;
f0100372:	bf 00 00 00 00       	mov    $0x0,%edi
f0100377:	eb 10                	jmp    f0100389 <strtol+0x43>
f0100379:	bf 00 00 00 00       	mov    $0x0,%edi
		s++;

	// plus/minus sign
	if (*s == '+')
		s++;
	else if (*s == '-')
f010037e:	3c 2d                	cmp    $0x2d,%al
f0100380:	75 07                	jne    f0100389 <strtol+0x43>
		s++, neg = 1;
f0100382:	83 c2 01             	add    $0x1,%edx
f0100385:	66 bf 01 00          	mov    $0x1,%di

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
f0100389:	83 7c 24 1c 00       	cmpl   $0x0,0x1c(%esp)
f010038e:	0f 94 c0             	sete   %al
f0100391:	74 07                	je     f010039a <strtol+0x54>
f0100393:	83 7c 24 1c 10       	cmpl   $0x10,0x1c(%esp)
f0100398:	75 18                	jne    f01003b2 <strtol+0x6c>
f010039a:	80 3a 30             	cmpb   $0x30,(%edx)
f010039d:	75 13                	jne    f01003b2 <strtol+0x6c>
f010039f:	80 7a 01 78          	cmpb   $0x78,0x1(%edx)
f01003a3:	75 0d                	jne    f01003b2 <strtol+0x6c>
		s += 2, base = 16;
f01003a5:	83 c2 02             	add    $0x2,%edx
f01003a8:	c7 44 24 1c 10 00 00 	movl   $0x10,0x1c(%esp)
f01003af:	00 
f01003b0:	eb 1c                	jmp    f01003ce <strtol+0x88>
	else if (base == 0 && s[0] == '0')
f01003b2:	84 c0                	test   %al,%al
f01003b4:	74 18                	je     f01003ce <strtol+0x88>
		s++, base = 8;
	else if (base == 0)
		base = 10;
f01003b6:	c7 44 24 1c 0a 00 00 	movl   $0xa,0x1c(%esp)
f01003bd:	00 
		s++, neg = 1;

	// hex or octal base prefix
	if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x'))
		s += 2, base = 16;
	else if (base == 0 && s[0] == '0')
f01003be:	80 3a 30             	cmpb   $0x30,(%edx)
f01003c1:	75 0b                	jne    f01003ce <strtol+0x88>
		s++, base = 8;
f01003c3:	83 c2 01             	add    $0x1,%edx
f01003c6:	c7 44 24 1c 08 00 00 	movl   $0x8,0x1c(%esp)
f01003cd:	00 
	else if (base == 0)
		base = 10;
f01003ce:	b8 00 00 00 00       	mov    $0x0,%eax

	// digits
	while (1) {
		int dig;

		if (*s >= '0' && *s <= '9')
f01003d3:	0f b6 0a             	movzbl (%edx),%ecx
f01003d6:	8d 69 d0             	lea    -0x30(%ecx),%ebp
f01003d9:	89 eb                	mov    %ebp,%ebx
f01003db:	80 fb 09             	cmp    $0x9,%bl
f01003de:	77 08                	ja     f01003e8 <strtol+0xa2>
			dig = *s - '0';
f01003e0:	0f be c9             	movsbl %cl,%ecx
f01003e3:	83 e9 30             	sub    $0x30,%ecx
f01003e6:	eb 22                	jmp    f010040a <strtol+0xc4>
		else if (*s >= 'a' && *s <= 'z')
f01003e8:	8d 69 9f             	lea    -0x61(%ecx),%ebp
f01003eb:	89 eb                	mov    %ebp,%ebx
f01003ed:	80 fb 19             	cmp    $0x19,%bl
f01003f0:	77 08                	ja     f01003fa <strtol+0xb4>
			dig = *s - 'a' + 10;
f01003f2:	0f be c9             	movsbl %cl,%ecx
f01003f5:	83 e9 57             	sub    $0x57,%ecx
f01003f8:	eb 10                	jmp    f010040a <strtol+0xc4>
		else if (*s >= 'A' && *s <= 'Z')
f01003fa:	8d 69 bf             	lea    -0x41(%ecx),%ebp
f01003fd:	89 eb                	mov    %ebp,%ebx
f01003ff:	80 fb 19             	cmp    $0x19,%bl
f0100402:	77 19                	ja     f010041d <strtol+0xd7>
			dig = *s - 'A' + 10;
f0100404:	0f be c9             	movsbl %cl,%ecx
f0100407:	83 e9 37             	sub    $0x37,%ecx
		else
			break;
		if (dig >= base)
f010040a:	3b 4c 24 1c          	cmp    0x1c(%esp),%ecx
f010040e:	7d 11                	jge    f0100421 <strtol+0xdb>
			break;
		s++, val = (val * base) + dig;
f0100410:	83 c2 01             	add    $0x1,%edx
f0100413:	0f af 44 24 1c       	imul   0x1c(%esp),%eax
f0100418:	8d 04 01             	lea    (%ecx,%eax,1),%eax
		// we don't properly detect overflow!
	}
f010041b:	eb b6                	jmp    f01003d3 <strtol+0x8d>

		if (*s >= '0' && *s <= '9')
			dig = *s - '0';
		else if (*s >= 'a' && *s <= 'z')
			dig = *s - 'a' + 10;
		else if (*s >= 'A' && *s <= 'Z')
f010041d:	89 c1                	mov    %eax,%ecx
f010041f:	eb 02                	jmp    f0100423 <strtol+0xdd>
			dig = *s - 'A' + 10;
		else
			break;
		if (dig >= base)
f0100421:	89 c1                	mov    %eax,%ecx
			break;
		s++, val = (val * base) + dig;
		// we don't properly detect overflow!
	}

	if (endptr)
f0100423:	85 f6                	test   %esi,%esi
f0100425:	74 02                	je     f0100429 <strtol+0xe3>
		*endptr = (char *) s;
f0100427:	89 16                	mov    %edx,(%esi)
	return (neg ? -val : val);
f0100429:	89 ca                	mov    %ecx,%edx
f010042b:	f7 da                	neg    %edx
f010042d:	85 ff                	test   %edi,%edi
f010042f:	0f 45 c2             	cmovne %edx,%eax
}
f0100432:	5b                   	pop    %ebx
f0100433:	5e                   	pop    %esi
f0100434:	5f                   	pop    %edi
f0100435:	5d                   	pop    %ebp
f0100436:	c3                   	ret    
	...

f0100438 <putch>:
};


static void
putch(int ch, struct printbuf *b)
{
f0100438:	53                   	push   %ebx
f0100439:	83 ec 18             	sub    $0x18,%esp
f010043c:	8b 5c 24 24          	mov    0x24(%esp),%ebx
	b->buf[b->idx++] = ch;
f0100440:	8b 03                	mov    (%ebx),%eax
f0100442:	8b 54 24 20          	mov    0x20(%esp),%edx
f0100446:	88 54 03 08          	mov    %dl,0x8(%ebx,%eax,1)
f010044a:	83 c0 01             	add    $0x1,%eax
f010044d:	89 03                	mov    %eax,(%ebx)
	if (b->idx == 256-1) {
f010044f:	3d ff 00 00 00       	cmp    $0xff,%eax
f0100454:	75 19                	jne    f010046f <putch+0x37>
		puts(b->buf, b->idx);
f0100456:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
f010045d:	00 
f010045e:	8d 43 08             	lea    0x8(%ebx),%eax
f0100461:	89 04 24             	mov    %eax,(%esp)
f0100464:	e8 d0 0a 00 00       	call   f0100f39 <puts>
		b->idx = 0;
f0100469:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	}
	b->cnt++;
f010046f:	83 43 04 01          	addl   $0x1,0x4(%ebx)
}
f0100473:	83 c4 18             	add    $0x18,%esp
f0100476:	5b                   	pop    %ebx
f0100477:	c3                   	ret    

f0100478 <vcprintf>:


int
vcprintf(const char *fmt, va_list ap)
{
f0100478:	81 ec 2c 01 00 00    	sub    $0x12c,%esp
	struct printbuf b;

	b.idx = 0;
f010047e:	c7 44 24 18 00 00 00 	movl   $0x0,0x18(%esp)
f0100485:	00 
	b.cnt = 0;
f0100486:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
f010048d:	00 
	vprintfmt((void*)putch, &b, fmt, ap);
f010048e:	8b 84 24 34 01 00 00 	mov    0x134(%esp),%eax
f0100495:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100499:	8b 84 24 30 01 00 00 	mov    0x130(%esp),%eax
f01004a0:	89 44 24 08          	mov    %eax,0x8(%esp)
f01004a4:	8d 44 24 18          	lea    0x18(%esp),%eax
f01004a8:	89 44 24 04          	mov    %eax,0x4(%esp)
f01004ac:	c7 04 24 38 04 10 f0 	movl   $0xf0100438,(%esp)
f01004b3:	e8 b7 01 00 00       	call   f010066f <vprintfmt>
	puts(b.buf, b.idx);
f01004b8:	8b 44 24 18          	mov    0x18(%esp),%eax
f01004bc:	89 44 24 04          	mov    %eax,0x4(%esp)
f01004c0:	8d 44 24 20          	lea    0x20(%esp),%eax
f01004c4:	89 04 24             	mov    %eax,(%esp)
f01004c7:	e8 6d 0a 00 00       	call   f0100f39 <puts>

	return b.cnt;
}
f01004cc:	8b 44 24 1c          	mov    0x1c(%esp),%eax
f01004d0:	81 c4 2c 01 00 00    	add    $0x12c,%esp
f01004d6:	c3                   	ret    

f01004d7 <cprintf>:

int
cprintf(const char *fmt, ...)
{
f01004d7:	83 ec 1c             	sub    $0x1c,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f01004da:	8d 44 24 24          	lea    0x24(%esp),%eax
	cnt = vcprintf(fmt, ap);
f01004de:	89 44 24 04          	mov    %eax,0x4(%esp)
f01004e2:	8b 44 24 20          	mov    0x20(%esp),%eax
f01004e6:	89 04 24             	mov    %eax,(%esp)
f01004e9:	e8 8a ff ff ff       	call   f0100478 <vcprintf>
	va_end(ap);

	return cnt;
}
f01004ee:	83 c4 1c             	add    $0x1c,%esp
f01004f1:	c3                   	ret    
	...

f0100500 <printnum>:
 * using specified putch function and associated pointer putdat.
 */
static void
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
f0100500:	55                   	push   %ebp
f0100501:	57                   	push   %edi
f0100502:	56                   	push   %esi
f0100503:	53                   	push   %ebx
f0100504:	83 ec 3c             	sub    $0x3c,%esp
f0100507:	89 c5                	mov    %eax,%ebp
f0100509:	89 d6                	mov    %edx,%esi
f010050b:	8b 44 24 50          	mov    0x50(%esp),%eax
f010050f:	89 44 24 24          	mov    %eax,0x24(%esp)
f0100513:	8b 54 24 54          	mov    0x54(%esp),%edx
f0100517:	89 54 24 20          	mov    %edx,0x20(%esp)
f010051b:	8b 5c 24 5c          	mov    0x5c(%esp),%ebx
f010051f:	8b 7c 24 60          	mov    0x60(%esp),%edi
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
f0100523:	b8 00 00 00 00       	mov    $0x0,%eax
f0100528:	39 d0                	cmp    %edx,%eax
f010052a:	72 13                	jb     f010053f <printnum+0x3f>
f010052c:	8b 4c 24 24          	mov    0x24(%esp),%ecx
f0100530:	39 4c 24 58          	cmp    %ecx,0x58(%esp)
f0100534:	76 09                	jbe    f010053f <printnum+0x3f>
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
f0100536:	83 eb 01             	sub    $0x1,%ebx
f0100539:	85 db                	test   %ebx,%ebx
f010053b:	7f 63                	jg     f01005a0 <printnum+0xa0>
f010053d:	eb 71                	jmp    f01005b0 <printnum+0xb0>
printnum(void (*putch)(int, void*), void *putdat,
	 unsigned long long num, unsigned base, int width, int padc)
{
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
f010053f:	89 7c 24 10          	mov    %edi,0x10(%esp)
f0100543:	83 eb 01             	sub    $0x1,%ebx
f0100546:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010054a:	8b 5c 24 58          	mov    0x58(%esp),%ebx
f010054e:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0100552:	8b 44 24 08          	mov    0x8(%esp),%eax
f0100556:	8b 54 24 0c          	mov    0xc(%esp),%edx
f010055a:	89 44 24 28          	mov    %eax,0x28(%esp)
f010055e:	89 54 24 2c          	mov    %edx,0x2c(%esp)
f0100562:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f0100569:	00 
f010056a:	8b 54 24 24          	mov    0x24(%esp),%edx
f010056e:	89 14 24             	mov    %edx,(%esp)
f0100571:	8b 4c 24 20          	mov    0x20(%esp),%ecx
f0100575:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f0100579:	e8 62 0f 00 00       	call   f01014e0 <__udivdi3>
f010057e:	8b 4c 24 28          	mov    0x28(%esp),%ecx
f0100582:	8b 5c 24 2c          	mov    0x2c(%esp),%ebx
f0100586:	89 4c 24 08          	mov    %ecx,0x8(%esp)
f010058a:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
f010058e:	89 04 24             	mov    %eax,(%esp)
f0100591:	89 54 24 04          	mov    %edx,0x4(%esp)
f0100595:	89 f2                	mov    %esi,%edx
f0100597:	89 e8                	mov    %ebp,%eax
f0100599:	e8 62 ff ff ff       	call   f0100500 <printnum>
f010059e:	eb 10                	jmp    f01005b0 <printnum+0xb0>
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
			putch(padc, putdat);
f01005a0:	89 74 24 04          	mov    %esi,0x4(%esp)
f01005a4:	89 3c 24             	mov    %edi,(%esp)
f01005a7:	ff d5                	call   *%ebp
	// first recursively print all preceding (more significant) digits
	if (num >= base) {
		printnum(putch, putdat, num / base, base, width - 1, padc);
	} else {
		// print any needed pad characters before first digit
		while (--width > 0)
f01005a9:	83 eb 01             	sub    $0x1,%ebx
f01005ac:	85 db                	test   %ebx,%ebx
f01005ae:	7f f0                	jg     f01005a0 <printnum+0xa0>
			putch(padc, putdat);
	}

	// then print this (the least significant) digit
	putch("0123456789abcdef"[num % base], putdat);
f01005b0:	89 74 24 04          	mov    %esi,0x4(%esp)
f01005b4:	8b 74 24 04          	mov    0x4(%esp),%esi
f01005b8:	8b 44 24 58          	mov    0x58(%esp),%eax
f01005bc:	89 44 24 08          	mov    %eax,0x8(%esp)
f01005c0:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f01005c7:	00 
f01005c8:	8b 54 24 24          	mov    0x24(%esp),%edx
f01005cc:	89 14 24             	mov    %edx,(%esp)
f01005cf:	8b 4c 24 20          	mov    0x20(%esp),%ecx
f01005d3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
f01005d7:	e8 84 10 00 00       	call   f0101660 <__umoddi3>
f01005dc:	89 74 24 04          	mov    %esi,0x4(%esp)
f01005e0:	0f be 80 88 51 10 f0 	movsbl -0xfefae78(%eax),%eax
f01005e7:	89 04 24             	mov    %eax,(%esp)
f01005ea:	ff d5                	call   *%ebp
}
f01005ec:	83 c4 3c             	add    $0x3c,%esp
f01005ef:	5b                   	pop    %ebx
f01005f0:	5e                   	pop    %esi
f01005f1:	5f                   	pop    %edi
f01005f2:	5d                   	pop    %ebp
f01005f3:	c3                   	ret    

f01005f4 <getuint>:
// Get an unsigned int of various possible sizes from a varargs list,
// depending on the lflag parameter.
static unsigned long long
getuint(va_list *ap, int lflag)
{
	if (lflag >= 2)
f01005f4:	83 fa 01             	cmp    $0x1,%edx
f01005f7:	7e 0d                	jle    f0100606 <getuint+0x12>
		return va_arg(*ap, unsigned long long);
f01005f9:	8b 10                	mov    (%eax),%edx
f01005fb:	8d 4a 08             	lea    0x8(%edx),%ecx
f01005fe:	89 08                	mov    %ecx,(%eax)
f0100600:	8b 02                	mov    (%edx),%eax
f0100602:	8b 52 04             	mov    0x4(%edx),%edx
f0100605:	c3                   	ret    
	else if (lflag)
f0100606:	85 d2                	test   %edx,%edx
f0100608:	74 0f                	je     f0100619 <getuint+0x25>
		return va_arg(*ap, unsigned long);
f010060a:	8b 10                	mov    (%eax),%edx
f010060c:	8d 4a 04             	lea    0x4(%edx),%ecx
f010060f:	89 08                	mov    %ecx,(%eax)
f0100611:	8b 02                	mov    (%edx),%eax
f0100613:	ba 00 00 00 00       	mov    $0x0,%edx
f0100618:	c3                   	ret    
	else
		return va_arg(*ap, unsigned int);
f0100619:	8b 10                	mov    (%eax),%edx
f010061b:	8d 4a 04             	lea    0x4(%edx),%ecx
f010061e:	89 08                	mov    %ecx,(%eax)
f0100620:	8b 02                	mov    (%edx),%eax
f0100622:	ba 00 00 00 00       	mov    $0x0,%edx
}
f0100627:	c3                   	ret    

f0100628 <sprintputch>:
	int cnt;
};

static void
sprintputch(int ch, struct sprintbuf *b)
{
f0100628:	8b 44 24 08          	mov    0x8(%esp),%eax
	b->cnt++;
f010062c:	83 40 08 01          	addl   $0x1,0x8(%eax)
	if (b->buf < b->ebuf)
f0100630:	8b 10                	mov    (%eax),%edx
f0100632:	3b 50 04             	cmp    0x4(%eax),%edx
f0100635:	73 0b                	jae    f0100642 <sprintputch+0x1a>
		*b->buf++ = ch;
f0100637:	8b 4c 24 04          	mov    0x4(%esp),%ecx
f010063b:	88 0a                	mov    %cl,(%edx)
f010063d:	83 c2 01             	add    $0x1,%edx
f0100640:	89 10                	mov    %edx,(%eax)
f0100642:	f3 c3                	repz ret 

f0100644 <printfmt>:
	}
}

void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...)
{
f0100644:	83 ec 1c             	sub    $0x1c,%esp
	va_list ap;

	va_start(ap, fmt);
f0100647:	8d 44 24 2c          	lea    0x2c(%esp),%eax
	vprintfmt(putch, putdat, fmt, ap);
f010064b:	89 44 24 0c          	mov    %eax,0xc(%esp)
f010064f:	8b 44 24 28          	mov    0x28(%esp),%eax
f0100653:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100657:	8b 44 24 24          	mov    0x24(%esp),%eax
f010065b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010065f:	8b 44 24 20          	mov    0x20(%esp),%eax
f0100663:	89 04 24             	mov    %eax,(%esp)
f0100666:	e8 04 00 00 00       	call   f010066f <vprintfmt>
	va_end(ap);
}
f010066b:	83 c4 1c             	add    $0x1c,%esp
f010066e:	c3                   	ret    

f010066f <vprintfmt>:
// Main function to format and print a string.
void printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...);

void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap)
{
f010066f:	55                   	push   %ebp
f0100670:	57                   	push   %edi
f0100671:	56                   	push   %esi
f0100672:	53                   	push   %ebx
f0100673:	83 ec 4c             	sub    $0x4c,%esp
f0100676:	8b 6c 24 60          	mov    0x60(%esp),%ebp
f010067a:	8b 7c 24 64          	mov    0x64(%esp),%edi
f010067e:	8b 5c 24 68          	mov    0x68(%esp),%ebx
f0100682:	eb 11                	jmp    f0100695 <vprintfmt+0x26>
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
			if (ch == '\0')
f0100684:	85 c0                	test   %eax,%eax
f0100686:	0f 84 40 04 00 00    	je     f0100acc <vprintfmt+0x45d>
				return;
			putch(ch, putdat);
f010068c:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100690:	89 04 24             	mov    %eax,(%esp)
f0100693:	ff d5                	call   *%ebp
	unsigned long long num;
	int base, lflag, width, precision, altflag;
	char padc;

	while (1) {
		while ((ch = *(unsigned char *) fmt++) != '%') {
f0100695:	0f b6 03             	movzbl (%ebx),%eax
f0100698:	83 c3 01             	add    $0x1,%ebx
f010069b:	83 f8 25             	cmp    $0x25,%eax
f010069e:	75 e4                	jne    f0100684 <vprintfmt+0x15>
f01006a0:	c6 44 24 28 20       	movb   $0x20,0x28(%esp)
f01006a5:	c7 44 24 2c 00 00 00 	movl   $0x0,0x2c(%esp)
f01006ac:	00 
f01006ad:	be ff ff ff ff       	mov    $0xffffffff,%esi
f01006b2:	c7 44 24 30 ff ff ff 	movl   $0xffffffff,0x30(%esp)
f01006b9:	ff 
f01006ba:	b9 00 00 00 00       	mov    $0x0,%ecx
f01006bf:	89 74 24 34          	mov    %esi,0x34(%esp)
f01006c3:	eb 34                	jmp    f01006f9 <vprintfmt+0x8a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01006c5:	8b 5c 24 24          	mov    0x24(%esp),%ebx

		// flag to pad on the right
		case '-':
			padc = '-';
f01006c9:	c6 44 24 28 2d       	movb   $0x2d,0x28(%esp)
f01006ce:	eb 29                	jmp    f01006f9 <vprintfmt+0x8a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01006d0:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			padc = '-';
			goto reswitch;

		// flag to pad with 0's instead of spaces
		case '0':
			padc = '0';
f01006d4:	c6 44 24 28 30       	movb   $0x30,0x28(%esp)
f01006d9:	eb 1e                	jmp    f01006f9 <vprintfmt+0x8a>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01006db:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			precision = va_arg(ap, int);
			goto process_precision;

		case '.':
			if (width < 0)
				width = 0;
f01006df:	c7 44 24 30 00 00 00 	movl   $0x0,0x30(%esp)
f01006e6:	00 
f01006e7:	eb 10                	jmp    f01006f9 <vprintfmt+0x8a>
			altflag = 1;
			goto reswitch;

		process_precision:
			if (width < 0)
				width = precision, precision = -1;
f01006e9:	8b 44 24 34          	mov    0x34(%esp),%eax
f01006ed:	89 44 24 30          	mov    %eax,0x30(%esp)
f01006f1:	c7 44 24 34 ff ff ff 	movl   $0xffffffff,0x34(%esp)
f01006f8:	ff 
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01006f9:	0f b6 03             	movzbl (%ebx),%eax
f01006fc:	0f b6 d0             	movzbl %al,%edx
f01006ff:	8d 73 01             	lea    0x1(%ebx),%esi
f0100702:	89 74 24 24          	mov    %esi,0x24(%esp)
f0100706:	83 e8 23             	sub    $0x23,%eax
f0100709:	3c 55                	cmp    $0x55,%al
f010070b:	0f 87 9c 03 00 00    	ja     f0100aad <vprintfmt+0x43e>
f0100711:	0f b6 c0             	movzbl %al,%eax
f0100714:	ff 24 85 00 50 10 f0 	jmp    *-0xfefb000(,%eax,4)
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
f010071b:	83 ea 30             	sub    $0x30,%edx
f010071e:	89 54 24 34          	mov    %edx,0x34(%esp)
				ch = *fmt;
f0100722:	8b 54 24 24          	mov    0x24(%esp),%edx
f0100726:	0f be 02             	movsbl (%edx),%eax
				if (ch < '0' || ch > '9')
f0100729:	8d 50 d0             	lea    -0x30(%eax),%edx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f010072c:	8b 5c 24 24          	mov    0x24(%esp),%ebx
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
				precision = precision * 10 + ch - '0';
				ch = *fmt;
				if (ch < '0' || ch > '9')
f0100730:	83 fa 09             	cmp    $0x9,%edx
f0100733:	77 5b                	ja     f0100790 <vprintfmt+0x121>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0100735:	8b 74 24 34          	mov    0x34(%esp),%esi
		case '5':
		case '6':
		case '7':
		case '8':
		case '9':
			for (precision = 0; ; ++fmt) {
f0100739:	83 c3 01             	add    $0x1,%ebx
				precision = precision * 10 + ch - '0';
f010073c:	8d 14 b6             	lea    (%esi,%esi,4),%edx
f010073f:	8d 74 50 d0          	lea    -0x30(%eax,%edx,2),%esi
				ch = *fmt;
f0100743:	0f be 03             	movsbl (%ebx),%eax
				if (ch < '0' || ch > '9')
f0100746:	8d 50 d0             	lea    -0x30(%eax),%edx
f0100749:	83 fa 09             	cmp    $0x9,%edx
f010074c:	76 eb                	jbe    f0100739 <vprintfmt+0xca>
f010074e:	89 74 24 34          	mov    %esi,0x34(%esp)
f0100752:	eb 3c                	jmp    f0100790 <vprintfmt+0x121>
					break;
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
f0100754:	8b 44 24 6c          	mov    0x6c(%esp),%eax
f0100758:	8d 50 04             	lea    0x4(%eax),%edx
f010075b:	89 54 24 6c          	mov    %edx,0x6c(%esp)
f010075f:	8b 00                	mov    (%eax),%eax
f0100761:	89 44 24 34          	mov    %eax,0x34(%esp)
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0100765:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			}
			goto process_precision;

		case '*':
			precision = va_arg(ap, int);
			goto process_precision;
f0100769:	eb 25                	jmp    f0100790 <vprintfmt+0x121>

		case '.':
			if (width < 0)
f010076b:	83 7c 24 30 00       	cmpl   $0x0,0x30(%esp)
f0100770:	0f 88 65 ff ff ff    	js     f01006db <vprintfmt+0x6c>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0100776:	8b 5c 24 24          	mov    0x24(%esp),%ebx
f010077a:	e9 7a ff ff ff       	jmp    f01006f9 <vprintfmt+0x8a>
f010077f:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			if (width < 0)
				width = 0;
			goto reswitch;

		case '#':
			altflag = 1;
f0100783:	c7 44 24 2c 01 00 00 	movl   $0x1,0x2c(%esp)
f010078a:	00 
			goto reswitch;
f010078b:	e9 69 ff ff ff       	jmp    f01006f9 <vprintfmt+0x8a>

		process_precision:
			if (width < 0)
f0100790:	83 7c 24 30 00       	cmpl   $0x0,0x30(%esp)
f0100795:	0f 89 5e ff ff ff    	jns    f01006f9 <vprintfmt+0x8a>
f010079b:	e9 49 ff ff ff       	jmp    f01006e9 <vprintfmt+0x7a>
				width = precision, precision = -1;
			goto reswitch;

		// long flag (doubled for long long)
		case 'l':
			lflag++;
f01007a0:	83 c1 01             	add    $0x1,%ecx
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01007a3:	8b 5c 24 24          	mov    0x24(%esp),%ebx
f01007a7:	e9 4d ff ff ff       	jmp    f01006f9 <vprintfmt+0x8a>
			lflag++;
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
f01007ac:	8b 44 24 6c          	mov    0x6c(%esp),%eax
f01007b0:	8d 50 04             	lea    0x4(%eax),%edx
f01007b3:	89 54 24 6c          	mov    %edx,0x6c(%esp)
f01007b7:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01007bb:	8b 00                	mov    (%eax),%eax
f01007bd:	89 04 24             	mov    %eax,(%esp)
f01007c0:	ff d5                	call   *%ebp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f01007c2:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			goto reswitch;

		// character
		case 'c':
			putch(va_arg(ap, int), putdat);
			break;
f01007c6:	e9 ca fe ff ff       	jmp    f0100695 <vprintfmt+0x26>

		// error message
		case 'e':
			err = va_arg(ap, int);
f01007cb:	8b 44 24 6c          	mov    0x6c(%esp),%eax
f01007cf:	8d 50 04             	lea    0x4(%eax),%edx
f01007d2:	89 54 24 6c          	mov    %edx,0x6c(%esp)
f01007d6:	8b 00                	mov    (%eax),%eax
f01007d8:	89 c2                	mov    %eax,%edx
f01007da:	c1 fa 1f             	sar    $0x1f,%edx
f01007dd:	31 d0                	xor    %edx,%eax
f01007df:	29 d0                	sub    %edx,%eax
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
f01007e1:	83 f8 08             	cmp    $0x8,%eax
f01007e4:	7f 0b                	jg     f01007f1 <vprintfmt+0x182>
f01007e6:	8b 14 85 60 51 10 f0 	mov    -0xfefaea0(,%eax,4),%edx
f01007ed:	85 d2                	test   %edx,%edx
f01007ef:	75 21                	jne    f0100812 <vprintfmt+0x1a3>
				printfmt(putch, putdat, "error %d", err);
f01007f1:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01007f5:	c7 44 24 08 a0 51 10 	movl   $0xf01051a0,0x8(%esp)
f01007fc:	f0 
f01007fd:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100801:	89 2c 24             	mov    %ebp,(%esp)
f0100804:	e8 3b fe ff ff       	call   f0100644 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0100809:	8b 5c 24 24          	mov    0x24(%esp),%ebx
		case 'e':
			err = va_arg(ap, int);
			if (err < 0)
				err = -err;
			if (err >= MAXERROR || (p = error_string[err]) == NULL)
				printfmt(putch, putdat, "error %d", err);
f010080d:	e9 83 fe ff ff       	jmp    f0100695 <vprintfmt+0x26>
			else
				printfmt(putch, putdat, "%s", p);
f0100812:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0100816:	c7 44 24 08 3c 5b 10 	movl   $0xf0105b3c,0x8(%esp)
f010081d:	f0 
f010081e:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100822:	89 2c 24             	mov    %ebp,(%esp)
f0100825:	e8 1a fe ff ff       	call   f0100644 <printfmt>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f010082a:	8b 5c 24 24          	mov    0x24(%esp),%ebx
f010082e:	e9 62 fe ff ff       	jmp    f0100695 <vprintfmt+0x26>
f0100833:	8b 74 24 34          	mov    0x34(%esp),%esi
f0100837:	8b 5c 24 24          	mov    0x24(%esp),%ebx
f010083b:	8b 44 24 30          	mov    0x30(%esp),%eax
f010083f:	89 44 24 38          	mov    %eax,0x38(%esp)
				printfmt(putch, putdat, "%s", p);
			break;

		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
f0100843:	8b 44 24 6c          	mov    0x6c(%esp),%eax
f0100847:	8d 50 04             	lea    0x4(%eax),%edx
f010084a:	89 54 24 6c          	mov    %edx,0x6c(%esp)
f010084e:	8b 00                	mov    (%eax),%eax
				p = "(null)";
f0100850:	85 c0                	test   %eax,%eax
f0100852:	ba 99 51 10 f0       	mov    $0xf0105199,%edx
f0100857:	0f 45 d0             	cmovne %eax,%edx
f010085a:	89 54 24 34          	mov    %edx,0x34(%esp)
			if (width > 0 && padc != '-')
f010085e:	83 7c 24 38 00       	cmpl   $0x0,0x38(%esp)
f0100863:	7e 07                	jle    f010086c <vprintfmt+0x1fd>
f0100865:	80 7c 24 28 2d       	cmpb   $0x2d,0x28(%esp)
f010086a:	75 14                	jne    f0100880 <vprintfmt+0x211>
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f010086c:	8b 54 24 34          	mov    0x34(%esp),%edx
f0100870:	0f be 02             	movsbl (%edx),%eax
f0100873:	85 c0                	test   %eax,%eax
f0100875:	0f 85 ac 00 00 00    	jne    f0100927 <vprintfmt+0x2b8>
f010087b:	e9 97 00 00 00       	jmp    f0100917 <vprintfmt+0x2a8>
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f0100880:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100884:	8b 44 24 34          	mov    0x34(%esp),%eax
f0100888:	89 04 24             	mov    %eax,(%esp)
f010088b:	e8 89 f7 ff ff       	call   f0100019 <strnlen>
f0100890:	8b 54 24 38          	mov    0x38(%esp),%edx
f0100894:	29 c2                	sub    %eax,%edx
f0100896:	89 54 24 30          	mov    %edx,0x30(%esp)
f010089a:	85 d2                	test   %edx,%edx
f010089c:	7e ce                	jle    f010086c <vprintfmt+0x1fd>
					putch(padc, putdat);
f010089e:	0f be 44 24 28       	movsbl 0x28(%esp),%eax
f01008a3:	89 74 24 38          	mov    %esi,0x38(%esp)
f01008a7:	89 5c 24 3c          	mov    %ebx,0x3c(%esp)
f01008ab:	89 d3                	mov    %edx,%ebx
f01008ad:	89 c6                	mov    %eax,%esi
f01008af:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01008b3:	89 34 24             	mov    %esi,(%esp)
f01008b6:	ff d5                	call   *%ebp
		// string
		case 's':
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
f01008b8:	83 eb 01             	sub    $0x1,%ebx
f01008bb:	85 db                	test   %ebx,%ebx
f01008bd:	7f f0                	jg     f01008af <vprintfmt+0x240>
f01008bf:	8b 74 24 38          	mov    0x38(%esp),%esi
f01008c3:	8b 5c 24 3c          	mov    0x3c(%esp),%ebx
f01008c7:	c7 44 24 30 00 00 00 	movl   $0x0,0x30(%esp)
f01008ce:	00 
f01008cf:	eb 9b                	jmp    f010086c <vprintfmt+0x1fd>
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
f01008d1:	83 7c 24 2c 00       	cmpl   $0x0,0x2c(%esp)
f01008d6:	74 19                	je     f01008f1 <vprintfmt+0x282>
f01008d8:	8d 50 e0             	lea    -0x20(%eax),%edx
f01008db:	83 fa 5e             	cmp    $0x5e,%edx
f01008de:	76 11                	jbe    f01008f1 <vprintfmt+0x282>
					putch('?', putdat);
f01008e0:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01008e4:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
f01008eb:	ff 54 24 28          	call   *0x28(%esp)
f01008ef:	eb 0b                	jmp    f01008fc <vprintfmt+0x28d>
				else
					putch(ch, putdat);
f01008f1:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01008f5:	89 04 24             	mov    %eax,(%esp)
f01008f8:	ff 54 24 28          	call   *0x28(%esp)
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f01008fc:	83 ed 01             	sub    $0x1,%ebp
f01008ff:	0f be 03             	movsbl (%ebx),%eax
f0100902:	85 c0                	test   %eax,%eax
f0100904:	74 05                	je     f010090b <vprintfmt+0x29c>
f0100906:	83 c3 01             	add    $0x1,%ebx
f0100909:	eb 31                	jmp    f010093c <vprintfmt+0x2cd>
f010090b:	89 6c 24 30          	mov    %ebp,0x30(%esp)
f010090f:	8b 6c 24 28          	mov    0x28(%esp),%ebp
f0100913:	8b 5c 24 38          	mov    0x38(%esp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f0100917:	83 7c 24 30 00       	cmpl   $0x0,0x30(%esp)
f010091c:	7f 35                	jg     f0100953 <vprintfmt+0x2e4>
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f010091e:	8b 5c 24 24          	mov    0x24(%esp),%ebx
f0100922:	e9 6e fd ff ff       	jmp    f0100695 <vprintfmt+0x26>
			if ((p = va_arg(ap, char *)) == NULL)
				p = "(null)";
			if (width > 0 && padc != '-')
				for (width -= strnlen(p, precision); width > 0; width--)
					putch(padc, putdat);
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
f0100927:	8b 54 24 34          	mov    0x34(%esp),%edx
f010092b:	83 c2 01             	add    $0x1,%edx
f010092e:	89 6c 24 28          	mov    %ebp,0x28(%esp)
f0100932:	8b 6c 24 30          	mov    0x30(%esp),%ebp
f0100936:	89 5c 24 38          	mov    %ebx,0x38(%esp)
f010093a:	89 d3                	mov    %edx,%ebx
f010093c:	85 f6                	test   %esi,%esi
f010093e:	78 91                	js     f01008d1 <vprintfmt+0x262>
f0100940:	83 ee 01             	sub    $0x1,%esi
f0100943:	79 8c                	jns    f01008d1 <vprintfmt+0x262>
f0100945:	89 6c 24 30          	mov    %ebp,0x30(%esp)
f0100949:	8b 6c 24 28          	mov    0x28(%esp),%ebp
f010094d:	8b 5c 24 38          	mov    0x38(%esp),%ebx
f0100951:	eb c4                	jmp    f0100917 <vprintfmt+0x2a8>
f0100953:	89 de                	mov    %ebx,%esi
f0100955:	8b 5c 24 30          	mov    0x30(%esp),%ebx
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
				putch(' ', putdat);
f0100959:	89 7c 24 04          	mov    %edi,0x4(%esp)
f010095d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
f0100964:	ff d5                	call   *%ebp
			for (; (ch = *p++) != '\0' && (precision < 0 || --precision >= 0); width--)
				if (altflag && (ch < ' ' || ch > '~'))
					putch('?', putdat);
				else
					putch(ch, putdat);
			for (; width > 0; width--)
f0100966:	83 eb 01             	sub    $0x1,%ebx
f0100969:	85 db                	test   %ebx,%ebx
f010096b:	7f ec                	jg     f0100959 <vprintfmt+0x2ea>
f010096d:	89 f3                	mov    %esi,%ebx
f010096f:	e9 21 fd ff ff       	jmp    f0100695 <vprintfmt+0x26>
// Same as getuint but signed - can't use getuint
// because of sign extension
static long long
getint(va_list *ap, int lflag)
{
	if (lflag >= 2)
f0100974:	83 f9 01             	cmp    $0x1,%ecx
f0100977:	7e 12                	jle    f010098b <vprintfmt+0x31c>
		return va_arg(*ap, long long);
f0100979:	8b 44 24 6c          	mov    0x6c(%esp),%eax
f010097d:	8d 50 08             	lea    0x8(%eax),%edx
f0100980:	89 54 24 6c          	mov    %edx,0x6c(%esp)
f0100984:	8b 18                	mov    (%eax),%ebx
f0100986:	8b 70 04             	mov    0x4(%eax),%esi
f0100989:	eb 2a                	jmp    f01009b5 <vprintfmt+0x346>
	else if (lflag)
f010098b:	85 c9                	test   %ecx,%ecx
f010098d:	74 14                	je     f01009a3 <vprintfmt+0x334>
		return va_arg(*ap, long);
f010098f:	8b 44 24 6c          	mov    0x6c(%esp),%eax
f0100993:	8d 50 04             	lea    0x4(%eax),%edx
f0100996:	89 54 24 6c          	mov    %edx,0x6c(%esp)
f010099a:	8b 18                	mov    (%eax),%ebx
f010099c:	89 de                	mov    %ebx,%esi
f010099e:	c1 fe 1f             	sar    $0x1f,%esi
f01009a1:	eb 12                	jmp    f01009b5 <vprintfmt+0x346>
	else
		return va_arg(*ap, int);
f01009a3:	8b 44 24 6c          	mov    0x6c(%esp),%eax
f01009a7:	8d 50 04             	lea    0x4(%eax),%edx
f01009aa:	89 54 24 6c          	mov    %edx,0x6c(%esp)
f01009ae:	8b 18                	mov    (%eax),%ebx
f01009b0:	89 de                	mov    %ebx,%esi
f01009b2:	c1 fe 1f             	sar    $0x1f,%esi
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
				putch('-', putdat);
				num = -(long long) num;
			}
			base = 10;
f01009b5:	b8 0a 00 00 00       	mov    $0xa,%eax
			break;

		// (signed) decimal
		case 'd':
			num = getint(&ap, lflag);
			if ((long long) num < 0) {
f01009ba:	85 f6                	test   %esi,%esi
f01009bc:	0f 89 ab 00 00 00    	jns    f0100a6d <vprintfmt+0x3fe>
				putch('-', putdat);
f01009c2:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01009c6:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
f01009cd:	ff d5                	call   *%ebp
				num = -(long long) num;
f01009cf:	f7 db                	neg    %ebx
f01009d1:	83 d6 00             	adc    $0x0,%esi
f01009d4:	f7 de                	neg    %esi
			}
			base = 10;
f01009d6:	b8 0a 00 00 00       	mov    $0xa,%eax
f01009db:	e9 8d 00 00 00       	jmp    f0100a6d <vprintfmt+0x3fe>
			goto number;

		// unsigned decimal
		case 'u':
			num = getuint(&ap, lflag);
f01009e0:	89 ca                	mov    %ecx,%edx
f01009e2:	8d 44 24 6c          	lea    0x6c(%esp),%eax
f01009e6:	e8 09 fc ff ff       	call   f01005f4 <getuint>
f01009eb:	89 c3                	mov    %eax,%ebx
f01009ed:	89 d6                	mov    %edx,%esi
			base = 10;
f01009ef:	b8 0a 00 00 00       	mov    $0xa,%eax
			goto number;
f01009f4:	eb 77                	jmp    f0100a6d <vprintfmt+0x3fe>

		// (unsigned) octal
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
f01009f6:	89 7c 24 04          	mov    %edi,0x4(%esp)
f01009fa:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
f0100a01:	ff d5                	call   *%ebp
			putch('X', putdat);
f0100a03:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100a07:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
f0100a0e:	ff d5                	call   *%ebp
			putch('X', putdat);
f0100a10:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100a14:	c7 04 24 58 00 00 00 	movl   $0x58,(%esp)
f0100a1b:	ff d5                	call   *%ebp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0100a1d:	8b 5c 24 24          	mov    0x24(%esp),%ebx
		case 'o':
			// Replace this with your code.
			putch('X', putdat);
			putch('X', putdat);
			putch('X', putdat);
			break;
f0100a21:	e9 6f fc ff ff       	jmp    f0100695 <vprintfmt+0x26>

		// pointer
		case 'p':
			putch('0', putdat);
f0100a26:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100a2a:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
f0100a31:	ff d5                	call   *%ebp
			putch('x', putdat);
f0100a33:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100a37:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
f0100a3e:	ff d5                	call   *%ebp
			num = (unsigned long long)
				(uintptr_t) va_arg(ap, void *);
f0100a40:	8b 44 24 6c          	mov    0x6c(%esp),%eax
f0100a44:	8d 50 04             	lea    0x4(%eax),%edx
f0100a47:	89 54 24 6c          	mov    %edx,0x6c(%esp)

		// pointer
		case 'p':
			putch('0', putdat);
			putch('x', putdat);
			num = (unsigned long long)
f0100a4b:	8b 18                	mov    (%eax),%ebx
f0100a4d:	be 00 00 00 00       	mov    $0x0,%esi
				(uintptr_t) va_arg(ap, void *);
			base = 16;
f0100a52:	b8 10 00 00 00       	mov    $0x10,%eax
			goto number;
f0100a57:	eb 14                	jmp    f0100a6d <vprintfmt+0x3fe>

		// (unsigned) hexadecimal
		case 'x':
			num = getuint(&ap, lflag);
f0100a59:	89 ca                	mov    %ecx,%edx
f0100a5b:	8d 44 24 6c          	lea    0x6c(%esp),%eax
f0100a5f:	e8 90 fb ff ff       	call   f01005f4 <getuint>
f0100a64:	89 c3                	mov    %eax,%ebx
f0100a66:	89 d6                	mov    %edx,%esi
			base = 16;
f0100a68:	b8 10 00 00 00       	mov    $0x10,%eax
		number:
			printnum(putch, putdat, num, base, width, padc);
f0100a6d:	0f be 54 24 28       	movsbl 0x28(%esp),%edx
f0100a72:	89 54 24 10          	mov    %edx,0x10(%esp)
f0100a76:	8b 54 24 30          	mov    0x30(%esp),%edx
f0100a7a:	89 54 24 0c          	mov    %edx,0xc(%esp)
f0100a7e:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100a82:	89 1c 24             	mov    %ebx,(%esp)
f0100a85:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100a89:	89 fa                	mov    %edi,%edx
f0100a8b:	89 e8                	mov    %ebp,%eax
f0100a8d:	e8 6e fa ff ff       	call   f0100500 <printnum>
			break;
f0100a92:	8b 5c 24 24          	mov    0x24(%esp),%ebx
f0100a96:	e9 fa fb ff ff       	jmp    f0100695 <vprintfmt+0x26>

		// escaped '%' character
		case '%':
			putch(ch, putdat);
f0100a9b:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100a9f:	89 14 24             	mov    %edx,(%esp)
f0100aa2:	ff d5                	call   *%ebp
		width = -1;
		precision = -1;
		lflag = 0;
		altflag = 0;
	reswitch:
		switch (ch = *(unsigned char *) fmt++) {
f0100aa4:	8b 5c 24 24          	mov    0x24(%esp),%ebx
			break;

		// escaped '%' character
		case '%':
			putch(ch, putdat);
			break;
f0100aa8:	e9 e8 fb ff ff       	jmp    f0100695 <vprintfmt+0x26>

		// unrecognized escape sequence - just print it literally
		default:
			putch('%', putdat);
f0100aad:	89 7c 24 04          	mov    %edi,0x4(%esp)
f0100ab1:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
f0100ab8:	ff d5                	call   *%ebp
			for (fmt--; fmt[-1] != '%'; fmt--)
f0100aba:	eb 02                	jmp    f0100abe <vprintfmt+0x44f>
f0100abc:	89 c3                	mov    %eax,%ebx
f0100abe:	8d 43 ff             	lea    -0x1(%ebx),%eax
f0100ac1:	80 7b ff 25          	cmpb   $0x25,-0x1(%ebx)
f0100ac5:	75 f5                	jne    f0100abc <vprintfmt+0x44d>
f0100ac7:	e9 c9 fb ff ff       	jmp    f0100695 <vprintfmt+0x26>
				/* do nothing */;
			break;
		}
	}
}
f0100acc:	83 c4 4c             	add    $0x4c,%esp
f0100acf:	5b                   	pop    %ebx
f0100ad0:	5e                   	pop    %esi
f0100ad1:	5f                   	pop    %edi
f0100ad2:	5d                   	pop    %ebp
f0100ad3:	c3                   	ret    

f0100ad4 <vsnprintf>:
		*b->buf++ = ch;
}

int
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
f0100ad4:	83 ec 2c             	sub    $0x2c,%esp
f0100ad7:	8b 44 24 30          	mov    0x30(%esp),%eax
f0100adb:	8b 54 24 34          	mov    0x34(%esp),%edx
	struct sprintbuf b = {buf, buf+n-1, 0};
f0100adf:	89 44 24 14          	mov    %eax,0x14(%esp)
f0100ae3:	8d 4c 10 ff          	lea    -0x1(%eax,%edx,1),%ecx
f0100ae7:	89 4c 24 18          	mov    %ecx,0x18(%esp)
f0100aeb:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
f0100af2:	00 

	if (buf == NULL || n < 1)
f0100af3:	85 c0                	test   %eax,%eax
f0100af5:	74 35                	je     f0100b2c <vsnprintf+0x58>
f0100af7:	85 d2                	test   %edx,%edx
f0100af9:	7e 31                	jle    f0100b2c <vsnprintf+0x58>
		return -E_INVAL;

	// print the string to the buffer
	vprintfmt((void*)sprintputch, &b, fmt, ap);
f0100afb:	8b 44 24 3c          	mov    0x3c(%esp),%eax
f0100aff:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100b03:	8b 44 24 38          	mov    0x38(%esp),%eax
f0100b07:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100b0b:	8d 44 24 14          	lea    0x14(%esp),%eax
f0100b0f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100b13:	c7 04 24 28 06 10 f0 	movl   $0xf0100628,(%esp)
f0100b1a:	e8 50 fb ff ff       	call   f010066f <vprintfmt>

	// null terminate the buffer
	*b.buf = '\0';
f0100b1f:	8b 44 24 14          	mov    0x14(%esp),%eax
f0100b23:	c6 00 00             	movb   $0x0,(%eax)

	return b.cnt;
f0100b26:	8b 44 24 1c          	mov    0x1c(%esp),%eax
f0100b2a:	eb 05                	jmp    f0100b31 <vsnprintf+0x5d>
vsnprintf(char *buf, int n, const char *fmt, va_list ap)
{
	struct sprintbuf b = {buf, buf+n-1, 0};

	if (buf == NULL || n < 1)
		return -E_INVAL;
f0100b2c:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax

	// null terminate the buffer
	*b.buf = '\0';

	return b.cnt;
}
f0100b31:	83 c4 2c             	add    $0x2c,%esp
f0100b34:	c3                   	ret    

f0100b35 <snprintf>:

int
snprintf(char *buf, int n, const char *fmt, ...)
{
f0100b35:	83 ec 1c             	sub    $0x1c,%esp
	va_list ap;
	int rc;

	va_start(ap, fmt);
f0100b38:	8d 44 24 2c          	lea    0x2c(%esp),%eax
	rc = vsnprintf(buf, n, fmt, ap);
f0100b3c:	89 44 24 0c          	mov    %eax,0xc(%esp)
f0100b40:	8b 44 24 28          	mov    0x28(%esp),%eax
f0100b44:	89 44 24 08          	mov    %eax,0x8(%esp)
f0100b48:	8b 44 24 24          	mov    0x24(%esp),%eax
f0100b4c:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100b50:	8b 44 24 20          	mov    0x20(%esp),%eax
f0100b54:	89 04 24             	mov    %eax,(%esp)
f0100b57:	e8 78 ff ff ff       	call   f0100ad4 <vsnprintf>
	va_end(ap);

	return rc;
}
f0100b5c:	83 c4 1c             	add    $0x1c,%esp
f0100b5f:	c3                   	ret    

f0100b60 <readline>:
extern int hist_head;
extern int hist_tail;
extern int hist_curr;

char *readline(const char *prompt)
{
f0100b60:	55                   	push   %ebp
f0100b61:	57                   	push   %edi
f0100b62:	56                   	push   %esi
f0100b63:	53                   	push   %ebx
f0100b64:	83 ec 1c             	sub    $0x1c,%esp
  int i, c;

  if (prompt != NULL)
f0100b67:	83 7c 24 30 00       	cmpl   $0x0,0x30(%esp)
f0100b6c:	74 14                	je     f0100b82 <readline+0x22>
    cprintf("%s", prompt);
f0100b6e:	8b 44 24 30          	mov    0x30(%esp),%eax
f0100b72:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100b76:	c7 04 24 3c 5b 10 f0 	movl   $0xf0105b3c,(%esp)
f0100b7d:	e8 55 f9 ff ff       	call   f01004d7 <cprintf>
          if (hist_curr != hist_tail)
            hist_curr = (hist_curr == SHELL_HIST_MAX-1) ? 0 : hist_curr+1;

          while (i --)
            cprintf("\b");
          for (i = 0 ; hist[hist_curr][i] ; i ++) {
f0100b82:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100b87:	eb 0c                	jmp    f0100b95 <readline+0x35>
          if (hist_curr != hist_head)
            hist_curr = (hist_curr == 0) ? SHELL_HIST_MAX-1 : hist_curr-1;

          while (i --)
            cprintf("\b");
          for (i = 0 ; hist[hist_curr][i] ; i ++) {
f0100b89:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100b8e:	eb 05                	jmp    f0100b95 <readline+0x35>
          if (hist_curr != hist_tail)
            hist_curr = (hist_curr == SHELL_HIST_MAX-1) ? 0 : hist_curr+1;

          while (i --)
            cprintf("\b");
          for (i = 0 ; hist[hist_curr][i] ; i ++) {
f0100b90:	bb 00 00 00 00       	mov    $0x0,%ebx
  if (prompt != NULL)
    cprintf("%s", prompt);

  i = 0;
  while (1) {
    c = getchar();
f0100b95:	e8 5d 03 00 00       	call   f0100ef7 <getchar>
f0100b9a:	89 c6                	mov    %eax,%esi

    // Fill the found command into current buffer
    if (is_tab && is_found && c != '\t') {
f0100b9c:	83 3d 00 b0 10 f0 00 	cmpl   $0x0,0xf010b000
f0100ba3:	74 59                	je     f0100bfe <readline+0x9e>
f0100ba5:	83 3d 04 b0 10 f0 00 	cmpl   $0x0,0xf010b004
f0100bac:	74 50                	je     f0100bfe <readline+0x9e>
f0100bae:	83 f8 09             	cmp    $0x9,%eax
f0100bb1:	74 4b                	je     f0100bfe <readline+0x9e>
      strcpy(buf, commands[tab_idx].name);
f0100bb3:	a1 08 b0 10 f0       	mov    0xf010b008,%eax
f0100bb8:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0100bbb:	8b 04 85 00 70 10 f0 	mov    -0xfef9000(,%eax,4),%eax
f0100bc2:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100bc6:	c7 04 24 20 b0 10 f0 	movl   $0xf010b020,(%esp)
f0100bcd:	e8 6c f4 ff ff       	call   f010003e <strcpy>
      i = strlen(buf);
f0100bd2:	c7 04 24 20 b0 10 f0 	movl   $0xf010b020,(%esp)
f0100bd9:	e8 22 f4 ff ff       	call   f0100000 <strlen>
f0100bde:	89 c3                	mov    %eax,%ebx
      tab_idx = 0;
f0100be0:	c7 05 08 b0 10 f0 00 	movl   $0x0,0xf010b008
f0100be7:	00 00 00 
      is_tab = 0;
f0100bea:	c7 05 00 b0 10 f0 00 	movl   $0x0,0xf010b000
f0100bf1:	00 00 00 
      is_found = 0;
f0100bf4:	c7 05 04 b0 10 f0 00 	movl   $0x0,0xf010b004
f0100bfb:	00 00 00 
    }

    if (c < 0) {
f0100bfe:	85 f6                	test   %esi,%esi
f0100c00:	79 1a                	jns    f0100c1c <readline+0xbc>
      cprintf("read error: %e\n", c);
f0100c02:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100c06:	c7 04 24 3c 52 10 f0 	movl   $0xf010523c,(%esp)
f0100c0d:	e8 c5 f8 ff ff       	call   f01004d7 <cprintf>
      return NULL;
f0100c12:	b8 00 00 00 00       	mov    $0x0,%eax
f0100c17:	e9 af 02 00 00       	jmp    f0100ecb <readline+0x36b>
    } else if ((c == '\b' || c == '\x7f') && i > 0) {
f0100c1c:	83 fe 08             	cmp    $0x8,%esi
f0100c1f:	74 05                	je     f0100c26 <readline+0xc6>
f0100c21:	83 fe 7f             	cmp    $0x7f,%esi
f0100c24:	75 18                	jne    f0100c3e <readline+0xde>
f0100c26:	85 db                	test   %ebx,%ebx
f0100c28:	7e 14                	jle    f0100c3e <readline+0xde>
      cprintf("\b");
f0100c2a:	c7 04 24 4c 52 10 f0 	movl   $0xf010524c,(%esp)
f0100c31:	e8 a1 f8 ff ff       	call   f01004d7 <cprintf>
      i--;
f0100c36:	83 eb 01             	sub    $0x1,%ebx
f0100c39:	e9 57 ff ff ff       	jmp    f0100b95 <readline+0x35>
    } else if (c >= ' ' && c <= 0x7E && i < BUFLEN-1) {
f0100c3e:	8d 46 e0             	lea    -0x20(%esi),%eax
f0100c41:	83 f8 5e             	cmp    $0x5e,%eax
f0100c44:	77 28                	ja     f0100c6e <readline+0x10e>
f0100c46:	81 fb fe 03 00 00    	cmp    $0x3fe,%ebx
f0100c4c:	7f 20                	jg     f0100c6e <readline+0x10e>
      cprintf("%c",c);
f0100c4e:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100c52:	c7 04 24 4e 52 10 f0 	movl   $0xf010524e,(%esp)
f0100c59:	e8 79 f8 ff ff       	call   f01004d7 <cprintf>
      buf[i++] = c;
f0100c5e:	89 f0                	mov    %esi,%eax
f0100c60:	88 83 20 b0 10 f0    	mov    %al,-0xfef4fe0(%ebx)
f0100c66:	83 c3 01             	add    $0x1,%ebx
f0100c69:	e9 27 ff ff ff       	jmp    f0100b95 <readline+0x35>
    } else if (c == '\n' || c == '\r') {
f0100c6e:	83 fe 0a             	cmp    $0xa,%esi
f0100c71:	74 05                	je     f0100c78 <readline+0x118>
f0100c73:	83 fe 0d             	cmp    $0xd,%esi
f0100c76:	75 1d                	jne    f0100c95 <readline+0x135>
      cprintf("\n");
f0100c78:	c7 04 24 06 58 10 f0 	movl   $0xf0105806,(%esp)
f0100c7f:	e8 53 f8 ff ff       	call   f01004d7 <cprintf>
      buf[i] = 0;
f0100c84:	c6 83 20 b0 10 f0 00 	movb   $0x0,-0xfef4fe0(%ebx)
      return buf;
f0100c8b:	b8 20 b0 10 f0       	mov    $0xf010b020,%eax
f0100c90:	e9 36 02 00 00       	jmp    f0100ecb <readline+0x36b>
    } else if (c == 0xc) { // ctrl-L or ctrl-l
f0100c95:	83 fe 0c             	cmp    $0xc,%esi
f0100c98:	75 1e                	jne    f0100cb8 <readline+0x158>
      cls();
f0100c9a:	e8 ce 03 00 00       	call   f010106d <cls>
      cprintf("%s", prompt);
f0100c9f:	8b 44 24 30          	mov    0x30(%esp),%eax
f0100ca3:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100ca7:	c7 04 24 3c 5b 10 f0 	movl   $0xf0105b3c,(%esp)
f0100cae:	e8 24 f8 ff ff       	call   f01004d7 <cprintf>
f0100cb3:	e9 dd fe ff ff       	jmp    f0100b95 <readline+0x35>
    } else if (c == '\t') {
f0100cb8:	83 fe 09             	cmp    $0x9,%esi
f0100cbb:	0f 85 dd 00 00 00    	jne    f0100d9e <readline+0x23e>
      // Start from previous match
      int curr_idx = (is_found) ? tab_idx+1 : 0;
f0100cc1:	bf 00 00 00 00       	mov    $0x0,%edi
f0100cc6:	83 3d 04 b0 10 f0 00 	cmpl   $0x0,0xf010b004
f0100ccd:	74 0f                	je     f0100cde <readline+0x17e>
f0100ccf:	8b 3d 08 b0 10 f0    	mov    0xf010b008,%edi
f0100cd5:	83 c7 01             	add    $0x1,%edi
f0100cd8:	66 be 00 00          	mov    $0x0,%si
f0100cdc:	eb 26                	jmp    f0100d04 <readline+0x1a4>

extern int hist_head;
extern int hist_tail;
extern int hist_curr;

char *readline(const char *prompt)
f0100cde:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f0100ce1:	8d 34 85 00 70 10 f0 	lea    -0xfef9000(,%eax,4),%esi
        int tmp;
        for (tmp = 0 ; tmp < strlen(commands[tab_idx].name)-i ; tmp ++)
          cprintf("\b");
      }

      for (curr_idx ; curr_idx < NCOMMANDS ; curr_idx ++) {
f0100ce8:	39 3d 84 51 10 f0    	cmp    %edi,0xf0105184
f0100cee:	7f 33                	jg     f0100d23 <readline+0x1c3>
f0100cf0:	e9 8e 00 00 00       	jmp    f0100d83 <readline+0x223>

      if (is_found) {
        // Clear the output of previous match
        int tmp;
        for (tmp = 0 ; tmp < strlen(commands[tab_idx].name)-i ; tmp ++)
          cprintf("\b");
f0100cf5:	c7 04 24 4c 52 10 f0 	movl   $0xf010524c,(%esp)
f0100cfc:	e8 d6 f7 ff ff       	call   f01004d7 <cprintf>
      int curr_idx = (is_found) ? tab_idx+1 : 0;

      if (is_found) {
        // Clear the output of previous match
        int tmp;
        for (tmp = 0 ; tmp < strlen(commands[tab_idx].name)-i ; tmp ++)
f0100d01:	83 c6 01             	add    $0x1,%esi
f0100d04:	a1 08 b0 10 f0       	mov    0xf010b008,%eax
f0100d09:	8d 04 40             	lea    (%eax,%eax,2),%eax
f0100d0c:	8b 04 85 00 70 10 f0 	mov    -0xfef9000(,%eax,4),%eax
f0100d13:	89 04 24             	mov    %eax,(%esp)
f0100d16:	e8 e5 f2 ff ff       	call   f0100000 <strlen>
f0100d1b:	29 d8                	sub    %ebx,%eax
f0100d1d:	39 c6                	cmp    %eax,%esi
f0100d1f:	7c d4                	jl     f0100cf5 <readline+0x195>
f0100d21:	eb bb                	jmp    f0100cde <readline+0x17e>
          cprintf("\b");
      }

      for (curr_idx ; curr_idx < NCOMMANDS ; curr_idx ++) {
        if (strncmp(commands[curr_idx].name, buf, i) == 0) {
f0100d23:	89 dd                	mov    %ebx,%ebp
f0100d25:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0100d29:	c7 44 24 04 20 b0 10 	movl   $0xf010b020,0x4(%esp)
f0100d30:	f0 
f0100d31:	8b 06                	mov    (%esi),%eax
f0100d33:	89 04 24             	mov    %eax,(%esp)
f0100d36:	e8 ec f3 ff ff       	call   f0100127 <strncmp>
f0100d3b:	85 c0                	test   %eax,%eax
f0100d3d:	75 36                	jne    f0100d75 <readline+0x215>
          // Show the found command, instead of changing the current buffer
          cprintf("%s", commands[curr_idx].name+i);
f0100d3f:	8d 04 7f             	lea    (%edi,%edi,2),%eax
f0100d42:	03 2c 85 00 70 10 f0 	add    -0xfef9000(,%eax,4),%ebp
f0100d49:	89 6c 24 04          	mov    %ebp,0x4(%esp)
f0100d4d:	c7 04 24 3c 5b 10 f0 	movl   $0xf0105b3c,(%esp)
f0100d54:	e8 7e f7 ff ff       	call   f01004d7 <cprintf>
          is_tab = 1;
f0100d59:	c7 05 00 b0 10 f0 01 	movl   $0x1,0xf010b000
f0100d60:	00 00 00 
          is_found = 1;
f0100d63:	c7 05 04 b0 10 f0 01 	movl   $0x1,0xf010b004
f0100d6a:	00 00 00 
          tab_idx = curr_idx;
f0100d6d:	89 3d 08 b0 10 f0    	mov    %edi,0xf010b008
          break;
f0100d73:	eb 0e                	jmp    f0100d83 <readline+0x223>
        int tmp;
        for (tmp = 0 ; tmp < strlen(commands[tab_idx].name)-i ; tmp ++)
          cprintf("\b");
      }

      for (curr_idx ; curr_idx < NCOMMANDS ; curr_idx ++) {
f0100d75:	83 c7 01             	add    $0x1,%edi
f0100d78:	83 c6 0c             	add    $0xc,%esi
f0100d7b:	39 3d 84 51 10 f0    	cmp    %edi,0xf0105184
f0100d81:	7f a0                	jg     f0100d23 <readline+0x1c3>
          is_found = 1;
          tab_idx = curr_idx;
          break;
        }
      }
      if (curr_idx == NCOMMANDS) {
f0100d83:	3b 3d 84 51 10 f0    	cmp    0xf0105184,%edi
f0100d89:	0f 85 06 fe ff ff    	jne    f0100b95 <readline+0x35>
          is_found = 0;
f0100d8f:	c7 05 04 b0 10 f0 00 	movl   $0x0,0xf010b004
f0100d96:	00 00 00 
f0100d99:	e9 f7 fd ff ff       	jmp    f0100b95 <readline+0x35>
      }

    } else if (c >= 0x80) {
f0100d9e:	83 fe 7f             	cmp    $0x7f,%esi
f0100da1:	0f 8e ee fd ff ff    	jle    f0100b95 <readline+0x35>
      switch (c)
f0100da7:	81 fe e2 00 00 00    	cmp    $0xe2,%esi
f0100dad:	74 11                	je     f0100dc0 <readline+0x260>
f0100daf:	81 fe e3 00 00 00    	cmp    $0xe3,%esi
f0100db5:	0f 85 da fd ff ff    	jne    f0100b95 <readline+0x35>
f0100dbb:	e9 85 00 00 00       	jmp    f0100e45 <readline+0x2e5>
      {
        case KEY_UP:
          if (hist_curr != hist_head)
f0100dc0:	a1 a0 4e 11 f0       	mov    0xf0114ea0,%eax
f0100dc5:	3b 05 a4 4e 11 f0    	cmp    0xf0114ea4,%eax
f0100dcb:	74 12                	je     f0100ddf <readline+0x27f>
            hist_curr = (hist_curr == 0) ? SHELL_HIST_MAX-1 : hist_curr-1;
f0100dcd:	8d 50 ff             	lea    -0x1(%eax),%edx
f0100dd0:	85 c0                	test   %eax,%eax
f0100dd2:	b8 09 00 00 00       	mov    $0x9,%eax
f0100dd7:	0f 45 c2             	cmovne %edx,%eax
f0100dda:	a3 a0 4e 11 f0       	mov    %eax,0xf0114ea0

          while (i --)
f0100ddf:	85 db                	test   %ebx,%ebx
f0100de1:	74 11                	je     f0100df4 <readline+0x294>
            cprintf("\b");
f0100de3:	c7 04 24 4c 52 10 f0 	movl   $0xf010524c,(%esp)
f0100dea:	e8 e8 f6 ff ff       	call   f01004d7 <cprintf>
      {
        case KEY_UP:
          if (hist_curr != hist_head)
            hist_curr = (hist_curr == 0) ? SHELL_HIST_MAX-1 : hist_curr-1;

          while (i --)
f0100def:	83 eb 01             	sub    $0x1,%ebx
f0100df2:	75 ef                	jne    f0100de3 <readline+0x283>
            cprintf("\b");
          for (i = 0 ; hist[hist_curr][i] ; i ++) {
f0100df4:	a1 a0 4e 11 f0       	mov    0xf0114ea0,%eax
f0100df9:	c1 e0 0a             	shl    $0xa,%eax
f0100dfc:	0f b6 80 c0 4e 11 f0 	movzbl -0xfeeb140(%eax),%eax
f0100e03:	84 c0                	test   %al,%al
f0100e05:	0f 84 7e fd ff ff    	je     f0100b89 <readline+0x29>
f0100e0b:	bb 00 00 00 00       	mov    $0x0,%ebx
            buf[i] = hist[hist_curr][i];
f0100e10:	88 83 20 b0 10 f0    	mov    %al,-0xfef4fe0(%ebx)
            cprintf("%c",buf[i]);
f0100e16:	0f be c0             	movsbl %al,%eax
f0100e19:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100e1d:	c7 04 24 4e 52 10 f0 	movl   $0xf010524e,(%esp)
f0100e24:	e8 ae f6 ff ff       	call   f01004d7 <cprintf>
          if (hist_curr != hist_head)
            hist_curr = (hist_curr == 0) ? SHELL_HIST_MAX-1 : hist_curr-1;

          while (i --)
            cprintf("\b");
          for (i = 0 ; hist[hist_curr][i] ; i ++) {
f0100e29:	83 c3 01             	add    $0x1,%ebx
f0100e2c:	a1 a0 4e 11 f0       	mov    0xf0114ea0,%eax
f0100e31:	c1 e0 0a             	shl    $0xa,%eax
f0100e34:	0f b6 84 03 c0 4e 11 	movzbl -0xfeeb140(%ebx,%eax,1),%eax
f0100e3b:	f0 
f0100e3c:	84 c0                	test   %al,%al
f0100e3e:	75 d0                	jne    f0100e10 <readline+0x2b0>
f0100e40:	e9 50 fd ff ff       	jmp    f0100b95 <readline+0x35>
            buf[i] = hist[hist_curr][i];
            cprintf("%c",buf[i]);
          }
          break;
        case KEY_DN:
          if (hist_curr != hist_tail)
f0100e45:	a1 a0 4e 11 f0       	mov    0xf0114ea0,%eax
f0100e4a:	3b 05 a8 4e 11 f0    	cmp    0xf0114ea8,%eax
f0100e50:	74 13                	je     f0100e65 <readline+0x305>
            hist_curr = (hist_curr == SHELL_HIST_MAX-1) ? 0 : hist_curr+1;
f0100e52:	8d 50 01             	lea    0x1(%eax),%edx
f0100e55:	83 f8 09             	cmp    $0x9,%eax
f0100e58:	b8 00 00 00 00       	mov    $0x0,%eax
f0100e5d:	0f 45 c2             	cmovne %edx,%eax
f0100e60:	a3 a0 4e 11 f0       	mov    %eax,0xf0114ea0

          while (i --)
f0100e65:	85 db                	test   %ebx,%ebx
f0100e67:	74 11                	je     f0100e7a <readline+0x31a>
            cprintf("\b");
f0100e69:	c7 04 24 4c 52 10 f0 	movl   $0xf010524c,(%esp)
f0100e70:	e8 62 f6 ff ff       	call   f01004d7 <cprintf>
          break;
        case KEY_DN:
          if (hist_curr != hist_tail)
            hist_curr = (hist_curr == SHELL_HIST_MAX-1) ? 0 : hist_curr+1;

          while (i --)
f0100e75:	83 eb 01             	sub    $0x1,%ebx
f0100e78:	75 ef                	jne    f0100e69 <readline+0x309>
            cprintf("\b");
          for (i = 0 ; hist[hist_curr][i] ; i ++) {
f0100e7a:	a1 a0 4e 11 f0       	mov    0xf0114ea0,%eax
f0100e7f:	c1 e0 0a             	shl    $0xa,%eax
f0100e82:	0f b6 80 c0 4e 11 f0 	movzbl -0xfeeb140(%eax),%eax
f0100e89:	84 c0                	test   %al,%al
f0100e8b:	0f 84 ff fc ff ff    	je     f0100b90 <readline+0x30>
f0100e91:	bb 00 00 00 00       	mov    $0x0,%ebx
            buf[i] = hist[hist_curr][i];
f0100e96:	88 83 20 b0 10 f0    	mov    %al,-0xfef4fe0(%ebx)
            cprintf("%c",buf[i]);
f0100e9c:	0f be c0             	movsbl %al,%eax
f0100e9f:	89 44 24 04          	mov    %eax,0x4(%esp)
f0100ea3:	c7 04 24 4e 52 10 f0 	movl   $0xf010524e,(%esp)
f0100eaa:	e8 28 f6 ff ff       	call   f01004d7 <cprintf>
          if (hist_curr != hist_tail)
            hist_curr = (hist_curr == SHELL_HIST_MAX-1) ? 0 : hist_curr+1;

          while (i --)
            cprintf("\b");
          for (i = 0 ; hist[hist_curr][i] ; i ++) {
f0100eaf:	83 c3 01             	add    $0x1,%ebx
f0100eb2:	a1 a0 4e 11 f0       	mov    0xf0114ea0,%eax
f0100eb7:	c1 e0 0a             	shl    $0xa,%eax
f0100eba:	0f b6 84 03 c0 4e 11 	movzbl -0xfeeb140(%ebx,%eax,1),%eax
f0100ec1:	f0 
f0100ec2:	84 c0                	test   %al,%al
f0100ec4:	75 d0                	jne    f0100e96 <readline+0x336>
f0100ec6:	e9 ca fc ff ff       	jmp    f0100b95 <readline+0x35>
          }
          break;
      }
    }
  }
}
f0100ecb:	83 c4 1c             	add    $0x1c,%esp
f0100ece:	5b                   	pop    %ebx
f0100ecf:	5e                   	pop    %esi
f0100ed0:	5f                   	pop    %edi
f0100ed1:	5d                   	pop    %ebp
f0100ed2:	c3                   	ret    
	...

f0100ed4 <cputchar>:
#include <inc/syscall.h>


void
cputchar(int ch)
{
f0100ed4:	83 ec 2c             	sub    $0x2c,%esp
	char c = ch;
f0100ed7:	8b 44 24 30          	mov    0x30(%esp),%eax
f0100edb:	88 44 24 1f          	mov    %al,0x1f(%esp)

	// Unlike standard Unix's putchar,
	// the cputchar function _always_ outputs to the system console.
	puts(&c, 1);
f0100edf:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
f0100ee6:	00 
f0100ee7:	8d 44 24 1f          	lea    0x1f(%esp),%eax
f0100eeb:	89 04 24             	mov    %eax,(%esp)
f0100eee:	e8 46 00 00 00       	call   f0100f39 <puts>
}
f0100ef3:	83 c4 2c             	add    $0x2c,%esp
f0100ef6:	c3                   	ret    

f0100ef7 <getchar>:

int
getchar(void)
{
f0100ef7:	83 ec 0c             	sub    $0xc,%esp
	int r;
	// sys_cgetc does not block, but getchar should.
	while ((r = getc()) == 0){};
f0100efa:	e8 09 00 00 00       	call   f0100f08 <getc>
f0100eff:	85 c0                	test   %eax,%eax
f0100f01:	74 f7                	je     f0100efa <getchar+0x3>
		//sys_yield();
	return r;
}
f0100f03:	83 c4 0c             	add    $0xc,%esp
f0100f06:	c3                   	ret    
	...

f0100f08 <getc>:

	return ret;
}


SYSCALL_NOARG(getc, int)
f0100f08:	83 ec 0c             	sub    $0xc,%esp
f0100f0b:	89 1c 24             	mov    %ebx,(%esp)
f0100f0e:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100f12:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f0100f16:	ba 00 00 00 00       	mov    $0x0,%edx
f0100f1b:	b8 01 00 00 00       	mov    $0x1,%eax
f0100f20:	89 d1                	mov    %edx,%ecx
f0100f22:	89 d3                	mov    %edx,%ebx
f0100f24:	89 d7                	mov    %edx,%edi
f0100f26:	89 d6                	mov    %edx,%esi
f0100f28:	cd 30                	int    $0x30

	return ret;
}


SYSCALL_NOARG(getc, int)
f0100f2a:	8b 1c 24             	mov    (%esp),%ebx
f0100f2d:	8b 74 24 04          	mov    0x4(%esp),%esi
f0100f31:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0100f35:	83 c4 0c             	add    $0xc,%esp
f0100f38:	c3                   	ret    

f0100f39 <puts>:

void
puts(const char *s, size_t len)
{
f0100f39:	83 ec 0c             	sub    $0xc,%esp
f0100f3c:	89 1c 24             	mov    %ebx,(%esp)
f0100f3f:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100f43:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f0100f47:	b8 00 00 00 00       	mov    $0x0,%eax
f0100f4c:	8b 4c 24 14          	mov    0x14(%esp),%ecx
f0100f50:	8b 54 24 10          	mov    0x10(%esp),%edx
f0100f54:	89 c3                	mov    %eax,%ebx
f0100f56:	89 c7                	mov    %eax,%edi
f0100f58:	89 c6                	mov    %eax,%esi
f0100f5a:	cd 30                	int    $0x30

void
puts(const char *s, size_t len)
{
	syscall(SYS_puts,(uint32_t)s, len, 0, 0, 0);
}
f0100f5c:	8b 1c 24             	mov    (%esp),%ebx
f0100f5f:	8b 74 24 04          	mov    0x4(%esp),%esi
f0100f63:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0100f67:	83 c4 0c             	add    $0xc,%esp
f0100f6a:	c3                   	ret    

f0100f6b <sleep>:
//see inc/syscall.h
void sleep(uint32_t ticks)
{
f0100f6b:	83 ec 0c             	sub    $0xc,%esp
f0100f6e:	89 1c 24             	mov    %ebx,(%esp)
f0100f71:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100f75:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f0100f79:	b9 00 00 00 00       	mov    $0x0,%ecx
f0100f7e:	b8 05 00 00 00       	mov    $0x5,%eax
f0100f83:	8b 54 24 10          	mov    0x10(%esp),%edx
f0100f87:	89 cb                	mov    %ecx,%ebx
f0100f89:	89 cf                	mov    %ecx,%edi
f0100f8b:	89 ce                	mov    %ecx,%esi
f0100f8d:	cd 30                	int    $0x30
}
//see inc/syscall.h
void sleep(uint32_t ticks)
{
    syscall(SYS_sleep,ticks,0,0,0,0);
}
f0100f8f:	8b 1c 24             	mov    (%esp),%ebx
f0100f92:	8b 74 24 04          	mov    0x4(%esp),%esi
f0100f96:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0100f9a:	83 c4 0c             	add    $0xc,%esp
f0100f9d:	c3                   	ret    

f0100f9e <settextcolor>:
void settextcolor(unsigned char forecolor,unsigned char backcolor){
f0100f9e:	83 ec 0c             	sub    $0xc,%esp
f0100fa1:	89 1c 24             	mov    %ebx,(%esp)
f0100fa4:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100fa8:	89 7c 24 08          	mov    %edi,0x8(%esp)
    syscall(SYS_settextcolor,forecolor,backcolor,0,0,0);
f0100fac:	0f b6 54 24 10       	movzbl 0x10(%esp),%edx
f0100fb1:	0f b6 4c 24 14       	movzbl 0x14(%esp),%ecx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f0100fb6:	bb 00 00 00 00       	mov    $0x0,%ebx
f0100fbb:	b8 09 00 00 00       	mov    $0x9,%eax
f0100fc0:	89 df                	mov    %ebx,%edi
f0100fc2:	89 de                	mov    %ebx,%esi
f0100fc4:	cd 30                	int    $0x30
{
    syscall(SYS_sleep,ticks,0,0,0,0);
}
void settextcolor(unsigned char forecolor,unsigned char backcolor){
    syscall(SYS_settextcolor,forecolor,backcolor,0,0,0);
}
f0100fc6:	8b 1c 24             	mov    (%esp),%ebx
f0100fc9:	8b 74 24 04          	mov    0x4(%esp),%esi
f0100fcd:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0100fd1:	83 c4 0c             	add    $0xc,%esp
f0100fd4:	c3                   	ret    

f0100fd5 <fork>:
void kill_self()
{
    int pid = getpid();
    syscall(SYS_kill,pid,0,0,0,0);
}
SYSCALL_NOARG(fork, int32_t)
f0100fd5:	83 ec 0c             	sub    $0xc,%esp
f0100fd8:	89 1c 24             	mov    %ebx,(%esp)
f0100fdb:	89 74 24 04          	mov    %esi,0x4(%esp)
f0100fdf:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f0100fe3:	ba 00 00 00 00       	mov    $0x0,%edx
f0100fe8:	b8 03 00 00 00       	mov    $0x3,%eax
f0100fed:	89 d1                	mov    %edx,%ecx
f0100fef:	89 d3                	mov    %edx,%ebx
f0100ff1:	89 d7                	mov    %edx,%edi
f0100ff3:	89 d6                	mov    %edx,%esi
f0100ff5:	cd 30                	int    $0x30
void kill_self()
{
    int pid = getpid();
    syscall(SYS_kill,pid,0,0,0,0);
}
SYSCALL_NOARG(fork, int32_t)
f0100ff7:	8b 1c 24             	mov    (%esp),%ebx
f0100ffa:	8b 74 24 04          	mov    0x4(%esp),%esi
f0100ffe:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0101002:	83 c4 0c             	add    $0xc,%esp
f0101005:	c3                   	ret    

f0101006 <getpid>:
SYSCALL_NOARG(getpid, int32_t)
f0101006:	83 ec 0c             	sub    $0xc,%esp
f0101009:	89 1c 24             	mov    %ebx,(%esp)
f010100c:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101010:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f0101014:	ba 00 00 00 00       	mov    $0x0,%edx
f0101019:	b8 02 00 00 00       	mov    $0x2,%eax
f010101e:	89 d1                	mov    %edx,%ecx
f0101020:	89 d3                	mov    %edx,%ebx
f0101022:	89 d7                	mov    %edx,%edi
f0101024:	89 d6                	mov    %edx,%esi
f0101026:	cd 30                	int    $0x30
{
    int pid = getpid();
    syscall(SYS_kill,pid,0,0,0,0);
}
SYSCALL_NOARG(fork, int32_t)
SYSCALL_NOARG(getpid, int32_t)
f0101028:	8b 1c 24             	mov    (%esp),%ebx
f010102b:	8b 74 24 04          	mov    0x4(%esp),%esi
f010102f:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0101033:	83 c4 0c             	add    $0xc,%esp
f0101036:	c3                   	ret    

f0101037 <kill_self>:
}
void settextcolor(unsigned char forecolor,unsigned char backcolor){
    syscall(SYS_settextcolor,forecolor,backcolor,0,0,0);
}
void kill_self()
{
f0101037:	83 ec 0c             	sub    $0xc,%esp
f010103a:	89 1c 24             	mov    %ebx,(%esp)
f010103d:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101041:	89 7c 24 08          	mov    %edi,0x8(%esp)
    int pid = getpid();
f0101045:	e8 bc ff ff ff       	call   f0101006 <getpid>
f010104a:	89 c2                	mov    %eax,%edx
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f010104c:	b9 00 00 00 00       	mov    $0x0,%ecx
f0101051:	b8 04 00 00 00       	mov    $0x4,%eax
f0101056:	89 cb                	mov    %ecx,%ebx
f0101058:	89 cf                	mov    %ecx,%edi
f010105a:	89 ce                	mov    %ecx,%esi
f010105c:	cd 30                	int    $0x30
}
void kill_self()
{
    int pid = getpid();
    syscall(SYS_kill,pid,0,0,0,0);
}
f010105e:	8b 1c 24             	mov    (%esp),%ebx
f0101061:	8b 74 24 04          	mov    0x4(%esp),%esi
f0101065:	8b 7c 24 08          	mov    0x8(%esp),%edi
f0101069:	83 c4 0c             	add    $0xc,%esp
f010106c:	c3                   	ret    

f010106d <cls>:
SYSCALL_NOARG(fork, int32_t)
SYSCALL_NOARG(getpid, int32_t)
SYSCALL_NOARG(cls, int32_t)
f010106d:	83 ec 0c             	sub    $0xc,%esp
f0101070:	89 1c 24             	mov    %ebx,(%esp)
f0101073:	89 74 24 04          	mov    %esi,0x4(%esp)
f0101077:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f010107b:	ba 00 00 00 00       	mov    $0x0,%edx
f0101080:	b8 0a 00 00 00       	mov    $0xa,%eax
f0101085:	89 d1                	mov    %edx,%ecx
f0101087:	89 d3                	mov    %edx,%ebx
f0101089:	89 d7                	mov    %edx,%edi
f010108b:	89 d6                	mov    %edx,%esi
f010108d:	cd 30                	int    $0x30
    int pid = getpid();
    syscall(SYS_kill,pid,0,0,0,0);
}
SYSCALL_NOARG(fork, int32_t)
SYSCALL_NOARG(getpid, int32_t)
SYSCALL_NOARG(cls, int32_t)
f010108f:	8b 1c 24             	mov    (%esp),%ebx
f0101092:	8b 74 24 04          	mov    0x4(%esp),%esi
f0101096:	8b 7c 24 08          	mov    0x8(%esp),%edi
f010109a:	83 c4 0c             	add    $0xc,%esp
f010109d:	c3                   	ret    

f010109e <get_num_free_page>:
SYSCALL_NOARG(get_num_free_page, int32_t)
f010109e:	83 ec 0c             	sub    $0xc,%esp
f01010a1:	89 1c 24             	mov    %ebx,(%esp)
f01010a4:	89 74 24 04          	mov    %esi,0x4(%esp)
f01010a8:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f01010ac:	ba 00 00 00 00       	mov    $0x0,%edx
f01010b1:	b8 07 00 00 00       	mov    $0x7,%eax
f01010b6:	89 d1                	mov    %edx,%ecx
f01010b8:	89 d3                	mov    %edx,%ebx
f01010ba:	89 d7                	mov    %edx,%edi
f01010bc:	89 d6                	mov    %edx,%esi
f01010be:	cd 30                	int    $0x30
    syscall(SYS_kill,pid,0,0,0,0);
}
SYSCALL_NOARG(fork, int32_t)
SYSCALL_NOARG(getpid, int32_t)
SYSCALL_NOARG(cls, int32_t)
SYSCALL_NOARG(get_num_free_page, int32_t)
f01010c0:	8b 1c 24             	mov    (%esp),%ebx
f01010c3:	8b 74 24 04          	mov    0x4(%esp),%esi
f01010c7:	8b 7c 24 08          	mov    0x8(%esp),%edi
f01010cb:	83 c4 0c             	add    $0xc,%esp
f01010ce:	c3                   	ret    

f01010cf <get_num_used_page>:
SYSCALL_NOARG(get_num_used_page, int32_t)
f01010cf:	83 ec 0c             	sub    $0xc,%esp
f01010d2:	89 1c 24             	mov    %ebx,(%esp)
f01010d5:	89 74 24 04          	mov    %esi,0x4(%esp)
f01010d9:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f01010dd:	ba 00 00 00 00       	mov    $0x0,%edx
f01010e2:	b8 06 00 00 00       	mov    $0x6,%eax
f01010e7:	89 d1                	mov    %edx,%ecx
f01010e9:	89 d3                	mov    %edx,%ebx
f01010eb:	89 d7                	mov    %edx,%edi
f01010ed:	89 d6                	mov    %edx,%esi
f01010ef:	cd 30                	int    $0x30
}
SYSCALL_NOARG(fork, int32_t)
SYSCALL_NOARG(getpid, int32_t)
SYSCALL_NOARG(cls, int32_t)
SYSCALL_NOARG(get_num_free_page, int32_t)
SYSCALL_NOARG(get_num_used_page, int32_t)
f01010f1:	8b 1c 24             	mov    (%esp),%ebx
f01010f4:	8b 74 24 04          	mov    0x4(%esp),%esi
f01010f8:	8b 7c 24 08          	mov    0x8(%esp),%edi
f01010fc:	83 c4 0c             	add    $0xc,%esp
f01010ff:	c3                   	ret    

f0101100 <get_ticks>:
//tick??????
SYSCALL_NOARG(get_ticks,unsigned long)
f0101100:	83 ec 0c             	sub    $0xc,%esp
f0101103:	89 1c 24             	mov    %ebx,(%esp)
f0101106:	89 74 24 04          	mov    %esi,0x4(%esp)
f010110a:	89 7c 24 08          	mov    %edi,0x8(%esp)
	//
	// The last clause tells the assembler that this can
	// potentially change the condition codes and arbitrary
	// memory locations.

	asm volatile("int %1\n"
f010110e:	ba 00 00 00 00       	mov    $0x0,%edx
f0101113:	b8 08 00 00 00       	mov    $0x8,%eax
f0101118:	89 d1                	mov    %edx,%ecx
f010111a:	89 d3                	mov    %edx,%ebx
f010111c:	89 d7                	mov    %edx,%edi
f010111e:	89 d6                	mov    %edx,%esi
f0101120:	cd 30                	int    $0x30
SYSCALL_NOARG(getpid, int32_t)
SYSCALL_NOARG(cls, int32_t)
SYSCALL_NOARG(get_num_free_page, int32_t)
SYSCALL_NOARG(get_num_used_page, int32_t)
//tick??????
SYSCALL_NOARG(get_ticks,unsigned long)
f0101122:	8b 1c 24             	mov    (%esp),%ebx
f0101125:	8b 74 24 04          	mov    0x4(%esp),%esi
f0101129:	8b 7c 24 08          	mov    0x8(%esp),%edi
f010112d:	83 c4 0c             	add    $0xc,%esp
f0101130:	c3                   	ret    
	...

f0101140 <mon_help>:
  cprintf("Free: %18d pages\n", get_num_free_page());
  return 0;
}

int mon_help(int argc, char **argv)
{
f0101140:	53                   	push   %ebx
f0101141:	83 ec 18             	sub    $0x18,%esp
f0101144:	bb 00 00 00 00       	mov    $0x0,%ebx
  int i;

  for (i = 0; i < NCOMMANDS; i++)
    cprintf("%s - %s\n", commands[i].name, commands[i].desc);
f0101149:	8b 83 04 70 10 f0    	mov    -0xfef8ffc(%ebx),%eax
f010114f:	89 44 24 08          	mov    %eax,0x8(%esp)
f0101153:	8b 83 00 70 10 f0    	mov    -0xfef9000(%ebx),%eax
f0101159:	89 44 24 04          	mov    %eax,0x4(%esp)
f010115d:	c7 04 24 51 52 10 f0 	movl   $0xf0105251,(%esp)
f0101164:	e8 6e f3 ff ff       	call   f01004d7 <cprintf>
f0101169:	83 c3 0c             	add    $0xc,%ebx

int mon_help(int argc, char **argv)
{
  int i;

  for (i = 0; i < NCOMMANDS; i++)
f010116c:	83 fb 3c             	cmp    $0x3c,%ebx
f010116f:	75 d8                	jne    f0101149 <mon_help+0x9>
    cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  return 0;
}
f0101171:	b8 00 00 00 00       	mov    $0x0,%eax
f0101176:	83 c4 18             	add    $0x18,%esp
f0101179:	5b                   	pop    %ebx
f010117a:	c3                   	ret    

f010117b <chgcolor>:
  cprintf("Now tick = %d\n", get_ticks());
  return 0;
}

int chgcolor(int argc, char **argv)
{
f010117b:	53                   	push   %ebx
f010117c:	83 ec 18             	sub    $0x18,%esp
  if (argc > 1)
f010117f:	83 7c 24 20 01       	cmpl   $0x1,0x20(%esp)
f0101184:	7e 35                	jle    f01011bb <chgcolor+0x40>
  {
    char fore = argv[1][0] - '0';
f0101186:	8b 44 24 24          	mov    0x24(%esp),%eax
f010118a:	8b 40 04             	mov    0x4(%eax),%eax
f010118d:	0f b6 18             	movzbl (%eax),%ebx
f0101190:	83 eb 30             	sub    $0x30,%ebx
    settextcolor(fore, 0);
f0101193:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
f010119a:	00 
f010119b:	0f b6 c3             	movzbl %bl,%eax
f010119e:	89 04 24             	mov    %eax,(%esp)
f01011a1:	e8 f8 fd ff ff       	call   f0100f9e <settextcolor>
    cprintf("Change color %d!\n", fore);
f01011a6:	0f be db             	movsbl %bl,%ebx
f01011a9:	89 5c 24 04          	mov    %ebx,0x4(%esp)
f01011ad:	c7 04 24 5a 52 10 f0 	movl   $0xf010525a,(%esp)
f01011b4:	e8 1e f3 ff ff       	call   f01004d7 <cprintf>
f01011b9:	eb 0c                	jmp    f01011c7 <chgcolor+0x4c>
  }
  else
  {
    cprintf("No input text color!\n");
f01011bb:	c7 04 24 6c 52 10 f0 	movl   $0xf010526c,(%esp)
f01011c2:	e8 10 f3 ff ff       	call   f01004d7 <cprintf>
  }
  return 0;
}
f01011c7:	b8 00 00 00 00       	mov    $0x0,%eax
f01011cc:	83 c4 18             	add    $0x18,%esp
f01011cf:	5b                   	pop    %ebx
f01011d0:	c3                   	ret    

f01011d1 <print_tick>:
    cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  return 0;
}

int print_tick(int argc, char **argv)
{
f01011d1:	83 ec 1c             	sub    $0x1c,%esp
  cprintf("Now tick = %d\n", get_ticks());
f01011d4:	e8 27 ff ff ff       	call   f0101100 <get_ticks>
f01011d9:	89 44 24 04          	mov    %eax,0x4(%esp)
f01011dd:	c7 04 24 82 52 10 f0 	movl   $0xf0105282,(%esp)
f01011e4:	e8 ee f2 ff ff       	call   f01004d7 <cprintf>
  return 0;
}
f01011e9:	b8 00 00 00 00       	mov    $0x0,%eax
f01011ee:	83 c4 1c             	add    $0x1c,%esp
f01011f1:	c3                   	ret    

f01011f2 <mem_stat>:
  { "forktest", "Test functionality of fork()", forktest }
};
const int NCOMMANDS = (sizeof(commands)/sizeof(commands[0]));

int mem_stat(int argc, char **argv)
{
f01011f2:	83 ec 1c             	sub    $0x1c,%esp
  cprintf("%-10s MEM_STAT %10s\n", "--------", "--------");
f01011f5:	c7 44 24 08 91 52 10 	movl   $0xf0105291,0x8(%esp)
f01011fc:	f0 
f01011fd:	c7 44 24 04 91 52 10 	movl   $0xf0105291,0x4(%esp)
f0101204:	f0 
f0101205:	c7 04 24 9a 52 10 f0 	movl   $0xf010529a,(%esp)
f010120c:	e8 c6 f2 ff ff       	call   f01004d7 <cprintf>
  cprintf("Used: %18d pages\n", get_num_used_page());
f0101211:	e8 b9 fe ff ff       	call   f01010cf <get_num_used_page>
f0101216:	89 44 24 04          	mov    %eax,0x4(%esp)
f010121a:	c7 04 24 af 52 10 f0 	movl   $0xf01052af,(%esp)
f0101221:	e8 b1 f2 ff ff       	call   f01004d7 <cprintf>
  cprintf("Free: %18d pages\n", get_num_free_page());
f0101226:	e8 73 fe ff ff       	call   f010109e <get_num_free_page>
f010122b:	89 44 24 04          	mov    %eax,0x4(%esp)
f010122f:	c7 04 24 c1 52 10 f0 	movl   $0xf01052c1,(%esp)
f0101236:	e8 9c f2 ff ff       	call   f01004d7 <cprintf>
  return 0;
}
f010123b:	b8 00 00 00 00       	mov    $0x0,%eax
f0101240:	83 c4 1c             	add    $0x1c,%esp
f0101243:	c3                   	ret    

f0101244 <task_job>:
}



void task_job()
{
f0101244:	56                   	push   %esi
f0101245:	53                   	push   %ebx
f0101246:	83 ec 14             	sub    $0x14,%esp
	int pid = 0;
	int i;

	pid = getpid();
f0101249:	e8 b8 fd ff ff       	call   f0101006 <getpid>
f010124e:	89 c6                	mov    %eax,%esi
	for (i = 0; i < 10; i++)
f0101250:	bb 00 00 00 00       	mov    $0x0,%ebx
	{
		cprintf("Im %d, now=%d\n", pid, i);
f0101255:	89 5c 24 08          	mov    %ebx,0x8(%esp)
f0101259:	89 74 24 04          	mov    %esi,0x4(%esp)
f010125d:	c7 04 24 d3 52 10 f0 	movl   $0xf01052d3,(%esp)
f0101264:	e8 6e f2 ff ff       	call   f01004d7 <cprintf>
		sleep(100);
f0101269:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
f0101270:	e8 f6 fc ff ff       	call   f0100f6b <sleep>
{
	int pid = 0;
	int i;

	pid = getpid();
	for (i = 0; i < 10; i++)
f0101275:	83 c3 01             	add    $0x1,%ebx
f0101278:	83 fb 0a             	cmp    $0xa,%ebx
f010127b:	75 d8                	jne    f0101255 <task_job+0x11>
	{
		cprintf("Im %d, now=%d\n", pid, i);
		sleep(100);
	}
}
f010127d:	83 c4 14             	add    $0x14,%esp
f0101280:	5b                   	pop    %ebx
f0101281:	5e                   	pop    %esi
f0101282:	c3                   	ret    

f0101283 <forktest>:

int forktest(int argc, char **argv)
{
f0101283:	83 ec 0c             	sub    $0xc,%esp
  /* Below code is running on user mode */
  if (!fork())
f0101286:	e8 4a fd ff ff       	call   f0100fd5 <fork>
f010128b:	85 c0                	test   %eax,%eax
f010128d:	75 48                	jne    f01012d7 <forktest+0x54>
  {

    /*Child*/
    task_job();
f010128f:	e8 b0 ff ff ff       	call   f0101244 <task_job>
    if (fork())
f0101294:	e8 3c fd ff ff       	call   f0100fd5 <fork>
f0101299:	85 c0                	test   %eax,%eax
f010129b:	74 0a                	je     f01012a7 <forktest+0x24>
f010129d:	8d 76 00             	lea    0x0(%esi),%esi
      task_job();
f01012a0:	e8 9f ff ff ff       	call   f0101244 <task_job>
f01012a5:	eb 30                	jmp    f01012d7 <forktest+0x54>
    else
    {
      if (fork())
f01012a7:	e8 29 fd ff ff       	call   f0100fd5 <fork>
f01012ac:	85 c0                	test   %eax,%eax
f01012ae:	66 90                	xchg   %ax,%ax
f01012b0:	74 07                	je     f01012b9 <forktest+0x36>
        task_job();
f01012b2:	e8 8d ff ff ff       	call   f0101244 <task_job>
f01012b7:	eb 1e                	jmp    f01012d7 <forktest+0x54>
f01012b9:	8d b4 26 00 00 00 00 	lea    0x0(%esi,%eiz,1),%esi
      else
        if (fork())
f01012c0:	e8 10 fd ff ff       	call   f0100fd5 <fork>
f01012c5:	85 c0                	test   %eax,%eax
f01012c7:	74 09                	je     f01012d2 <forktest+0x4f>
          task_job();
f01012c9:	e8 76 ff ff ff       	call   f0101244 <task_job>
f01012ce:	66 90                	xchg   %ax,%ax
f01012d0:	eb 05                	jmp    f01012d7 <forktest+0x54>
        else
          task_job();
f01012d2:	e8 6d ff ff ff       	call   f0101244 <task_job>
    }
  }
  /* task recycle */
  kill_self();
f01012d7:	e8 5b fd ff ff       	call   f0101037 <kill_self>
  return 0;
}
f01012dc:	b8 00 00 00 00       	mov    $0x0,%eax
f01012e1:	83 c4 0c             	add    $0xc,%esp
f01012e4:	c3                   	ret    

f01012e5 <shell>:

void shell()
{
f01012e5:	55                   	push   %ebp
f01012e6:	57                   	push   %edi
f01012e7:	56                   	push   %esi
f01012e8:	53                   	push   %ebx
f01012e9:	83 ec 5c             	sub    $0x5c,%esp
  char *buf;
  hist_head = 0;
f01012ec:	c7 05 a4 4e 11 f0 00 	movl   $0x0,0xf0114ea4
f01012f3:	00 00 00 
  hist_tail = 0;
f01012f6:	c7 05 a8 4e 11 f0 00 	movl   $0x0,0xf0114ea8
f01012fd:	00 00 00 
  hist_curr = 0;
f0101300:	c7 05 a0 4e 11 f0 00 	movl   $0x0,0xf0114ea0
f0101307:	00 00 00 

  cprintf("Welcome to the OSDI course!\n");
f010130a:	c7 04 24 e2 52 10 f0 	movl   $0xf01052e2,(%esp)
f0101311:	e8 c1 f1 ff ff       	call   f01004d7 <cprintf>
  cprintf("Type 'help' for a list of commands.\n");
f0101316:	c7 04 24 d4 53 10 f0 	movl   $0xf01053d4,(%esp)
f010131d:	e8 b5 f1 ff ff       	call   f01004d7 <cprintf>
  {
    buf = readline("OSDI> ");
    if (buf != NULL)
    {
      strcpy(hist[hist_tail], buf);
      hist_tail = (hist_tail + 1) % SHELL_HIST_MAX;
f0101322:	bd 67 66 66 66       	mov    $0x66666667,%ebp
  cprintf("Welcome to the OSDI course!\n");
  cprintf("Type 'help' for a list of commands.\n");

  while(1)
  {
    buf = readline("OSDI> ");
f0101327:	c7 04 24 ff 52 10 f0 	movl   $0xf01052ff,(%esp)
f010132e:	e8 2d f8 ff ff       	call   f0100b60 <readline>
f0101333:	89 c3                	mov    %eax,%ebx
    if (buf != NULL)
f0101335:	85 c0                	test   %eax,%eax
f0101337:	74 ee                	je     f0101327 <shell+0x42>
    {
      strcpy(hist[hist_tail], buf);
f0101339:	89 44 24 04          	mov    %eax,0x4(%esp)
f010133d:	a1 a8 4e 11 f0       	mov    0xf0114ea8,%eax
f0101342:	c1 e0 0a             	shl    $0xa,%eax
f0101345:	05 c0 4e 11 f0       	add    $0xf0114ec0,%eax
f010134a:	89 04 24             	mov    %eax,(%esp)
f010134d:	e8 ec ec ff ff       	call   f010003e <strcpy>
      hist_tail = (hist_tail + 1) % SHELL_HIST_MAX;
f0101352:	8b 35 a8 4e 11 f0    	mov    0xf0114ea8,%esi
f0101358:	83 c6 01             	add    $0x1,%esi
f010135b:	89 f0                	mov    %esi,%eax
f010135d:	f7 ed                	imul   %ebp
f010135f:	89 d1                	mov    %edx,%ecx
f0101361:	c1 f9 02             	sar    $0x2,%ecx
f0101364:	89 f0                	mov    %esi,%eax
f0101366:	c1 f8 1f             	sar    $0x1f,%eax
f0101369:	29 c1                	sub    %eax,%ecx
f010136b:	8d 04 89             	lea    (%ecx,%ecx,4),%eax
f010136e:	01 c0                	add    %eax,%eax
f0101370:	89 f1                	mov    %esi,%ecx
f0101372:	29 c1                	sub    %eax,%ecx
f0101374:	89 0d a8 4e 11 f0    	mov    %ecx,0xf0114ea8
      if (hist_head == hist_tail)
f010137a:	3b 0d a4 4e 11 f0    	cmp    0xf0114ea4,%ecx
f0101380:	75 2a                	jne    f01013ac <shell+0xc7>
      {
        hist_head = (hist_head + 1) % SHELL_HIST_MAX;
f0101382:	8d 71 01             	lea    0x1(%ecx),%esi
f0101385:	89 f0                	mov    %esi,%eax
f0101387:	f7 ed                	imul   %ebp
f0101389:	c1 fa 02             	sar    $0x2,%edx
f010138c:	89 f0                	mov    %esi,%eax
f010138e:	c1 f8 1f             	sar    $0x1f,%eax
f0101391:	29 c2                	sub    %eax,%edx
f0101393:	8d 04 92             	lea    (%edx,%edx,4),%eax
f0101396:	01 c0                	add    %eax,%eax
f0101398:	29 c6                	sub    %eax,%esi
f010139a:	89 35 a4 4e 11 f0    	mov    %esi,0xf0114ea4
        hist[hist_tail][0] = 0;
f01013a0:	89 c8                	mov    %ecx,%eax
f01013a2:	c1 e0 0a             	shl    $0xa,%eax
f01013a5:	c6 80 c0 4e 11 f0 00 	movb   $0x0,-0xfeeb140(%eax)
      }
      hist_curr = hist_tail;
f01013ac:	89 0d a0 4e 11 f0    	mov    %ecx,0xf0114ea0
  char *argv[MAXARGS];
  int i;

  // Parse the command buffer into whitespace-separated arguments
  argc = 0;
  argv[argc] = 0;
f01013b2:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
f01013b9:	00 
  int argc;
  char *argv[MAXARGS];
  int i;

  // Parse the command buffer into whitespace-separated arguments
  argc = 0;
f01013ba:	be 00 00 00 00       	mov    $0x0,%esi
f01013bf:	eb 06                	jmp    f01013c7 <shell+0xe2>
  argv[argc] = 0;
  while (1) {
    // gobble whitespace
    while (*buf && strchr(WHITESPACE, *buf))
      *buf++ = 0;
f01013c1:	c6 03 00             	movb   $0x0,(%ebx)
f01013c4:	83 c3 01             	add    $0x1,%ebx
  // Parse the command buffer into whitespace-separated arguments
  argc = 0;
  argv[argc] = 0;
  while (1) {
    // gobble whitespace
    while (*buf && strchr(WHITESPACE, *buf))
f01013c7:	0f b6 03             	movzbl (%ebx),%eax
f01013ca:	84 c0                	test   %al,%al
f01013cc:	74 70                	je     f010143e <shell+0x159>
f01013ce:	0f be c0             	movsbl %al,%eax
f01013d1:	89 44 24 04          	mov    %eax,0x4(%esp)
f01013d5:	c7 04 24 06 53 10 f0 	movl   $0xf0105306,(%esp)
f01013dc:	e8 90 ed ff ff       	call   f0100171 <strchr>
f01013e1:	85 c0                	test   %eax,%eax
f01013e3:	75 dc                	jne    f01013c1 <shell+0xdc>
      *buf++ = 0;
    if (*buf == 0)
f01013e5:	80 3b 00             	cmpb   $0x0,(%ebx)
f01013e8:	74 54                	je     f010143e <shell+0x159>
      break;

    // save and scan past next arg
    if (argc == MAXARGS-1) {
f01013ea:	83 fe 0f             	cmp    $0xf,%esi
f01013ed:	8d 76 00             	lea    0x0(%esi),%esi
f01013f0:	75 19                	jne    f010140b <shell+0x126>
      cprintf("Too many arguments (max %d)\n", MAXARGS);
f01013f2:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
f01013f9:	00 
f01013fa:	c7 04 24 0b 53 10 f0 	movl   $0xf010530b,(%esp)
f0101401:	e8 d1 f0 ff ff       	call   f01004d7 <cprintf>
f0101406:	e9 1c ff ff ff       	jmp    f0101327 <shell+0x42>
      return 0;
    }
    argv[argc++] = buf;
f010140b:	89 5c b4 10          	mov    %ebx,0x10(%esp,%esi,4)
f010140f:	83 c6 01             	add    $0x1,%esi
    while (*buf && !strchr(WHITESPACE, *buf))
f0101412:	0f b6 03             	movzbl (%ebx),%eax
f0101415:	84 c0                	test   %al,%al
f0101417:	75 0c                	jne    f0101425 <shell+0x140>
f0101419:	eb ac                	jmp    f01013c7 <shell+0xe2>
      buf++;
f010141b:	83 c3 01             	add    $0x1,%ebx
    if (argc == MAXARGS-1) {
      cprintf("Too many arguments (max %d)\n", MAXARGS);
      return 0;
    }
    argv[argc++] = buf;
    while (*buf && !strchr(WHITESPACE, *buf))
f010141e:	0f b6 03             	movzbl (%ebx),%eax
f0101421:	84 c0                	test   %al,%al
f0101423:	74 a2                	je     f01013c7 <shell+0xe2>
f0101425:	0f be c0             	movsbl %al,%eax
f0101428:	89 44 24 04          	mov    %eax,0x4(%esp)
f010142c:	c7 04 24 06 53 10 f0 	movl   $0xf0105306,(%esp)
f0101433:	e8 39 ed ff ff       	call   f0100171 <strchr>
f0101438:	85 c0                	test   %eax,%eax
f010143a:	74 df                	je     f010141b <shell+0x136>
f010143c:	eb 89                	jmp    f01013c7 <shell+0xe2>
      buf++;
  }
  argv[argc] = 0;
f010143e:	c7 44 b4 10 00 00 00 	movl   $0x0,0x10(%esp,%esi,4)
f0101445:	00 

  // Lookup and invoke the command
  if (argc == 0)
f0101446:	85 f6                	test   %esi,%esi
f0101448:	0f 84 d9 fe ff ff    	je     f0101327 <shell+0x42>
f010144e:	bb 00 70 10 f0       	mov    $0xf0107000,%ebx
f0101453:	bf 00 00 00 00       	mov    $0x0,%edi
    return 0;
  for (i = 0; i < NCOMMANDS; i++) {
    if (strcmp(argv[0], commands[i].name) == 0)
f0101458:	8b 03                	mov    (%ebx),%eax
f010145a:	89 44 24 04          	mov    %eax,0x4(%esp)
f010145e:	8b 44 24 10          	mov    0x10(%esp),%eax
f0101462:	89 04 24             	mov    %eax,(%esp)
f0101465:	e8 90 ec ff ff       	call   f01000fa <strcmp>
f010146a:	85 c0                	test   %eax,%eax
f010146c:	75 1d                	jne    f010148b <shell+0x1a6>
      return commands[i].func(argc, argv);
f010146e:	6b ff 0c             	imul   $0xc,%edi,%edi
f0101471:	8d 44 24 10          	lea    0x10(%esp),%eax
f0101475:	89 44 24 04          	mov    %eax,0x4(%esp)
f0101479:	89 34 24             	mov    %esi,(%esp)
f010147c:	ff 97 08 70 10 f0    	call   *-0xfef8ff8(%edi)
        hist_head = (hist_head + 1) % SHELL_HIST_MAX;
        hist[hist_tail][0] = 0;
      }
      hist_curr = hist_tail;

      if (runcmd(buf) < 0)
f0101482:	85 c0                	test   %eax,%eax
f0101484:	78 29                	js     f01014af <shell+0x1ca>
f0101486:	e9 9c fe ff ff       	jmp    f0101327 <shell+0x42>
  argv[argc] = 0;

  // Lookup and invoke the command
  if (argc == 0)
    return 0;
  for (i = 0; i < NCOMMANDS; i++) {
f010148b:	83 c7 01             	add    $0x1,%edi
f010148e:	83 c3 0c             	add    $0xc,%ebx
f0101491:	83 ff 05             	cmp    $0x5,%edi
f0101494:	75 c2                	jne    f0101458 <shell+0x173>
    if (strcmp(argv[0], commands[i].name) == 0)
      return commands[i].func(argc, argv);
  }
  cprintf("Unknown command '%s'\n", argv[0]);
f0101496:	8b 44 24 10          	mov    0x10(%esp),%eax
f010149a:	89 44 24 04          	mov    %eax,0x4(%esp)
f010149e:	c7 04 24 28 53 10 f0 	movl   $0xf0105328,(%esp)
f01014a5:	e8 2d f0 ff ff       	call   f01004d7 <cprintf>
f01014aa:	e9 78 fe ff ff       	jmp    f0101327 <shell+0x42>

      if (runcmd(buf) < 0)
        break;
    }
  }
}
f01014af:	83 c4 5c             	add    $0x5c,%esp
f01014b2:	5b                   	pop    %ebx
f01014b3:	5e                   	pop    %esi
f01014b4:	5f                   	pop    %edi
f01014b5:	5d                   	pop    %ebp
f01014b6:	c3                   	ret    
	...

f01014b8 <user_entry>:
#include <inc/stdio.h>
#include <inc/syscall.h>
#include <inc/shell.h>

int user_entry()
{
f01014b8:	83 ec 1c             	sub    $0x1c,%esp

	asm volatile("movl %0,%%eax\n\t" \
f01014bb:	b8 23 00 00 00       	mov    $0x23,%eax
f01014c0:	8e d8                	mov    %eax,%ds
f01014c2:	8e c0                	mov    %eax,%es
f01014c4:	8e e0                	mov    %eax,%fs
f01014c6:	8e e8                	mov    %eax,%gs
    "movw %%ax,%%fs\n\t" \
    "movw %%ax,%%gs" \
    :: "i" (0x20 | 0x03)
  );

  cprintf("Welcome to User Land, cheers!\n");
f01014c8:	c7 04 24 24 54 10 f0 	movl   $0xf0105424,(%esp)
f01014cf:	e8 03 f0 ff ff       	call   f01004d7 <cprintf>
  shell();
f01014d4:	e8 0c fe ff ff       	call   f01012e5 <shell>
f01014d9:	eb fe                	jmp    f01014d9 <user_entry+0x21>
f01014db:	00 00                	add    %al,(%eax)
f01014dd:	00 00                	add    %al,(%eax)
	...

f01014e0 <__udivdi3>:
f01014e0:	55                   	push   %ebp
f01014e1:	89 e5                	mov    %esp,%ebp
f01014e3:	57                   	push   %edi
f01014e4:	56                   	push   %esi
f01014e5:	8d 64 24 e0          	lea    -0x20(%esp),%esp
f01014e9:	8b 45 14             	mov    0x14(%ebp),%eax
f01014ec:	8b 75 08             	mov    0x8(%ebp),%esi
f01014ef:	8b 4d 10             	mov    0x10(%ebp),%ecx
f01014f2:	85 c0                	test   %eax,%eax
f01014f4:	89 75 e8             	mov    %esi,-0x18(%ebp)
f01014f7:	8b 7d 0c             	mov    0xc(%ebp),%edi
f01014fa:	89 4d f0             	mov    %ecx,-0x10(%ebp)
f01014fd:	75 39                	jne    f0101538 <__udivdi3+0x58>
f01014ff:	39 f9                	cmp    %edi,%ecx
f0101501:	77 65                	ja     f0101568 <__udivdi3+0x88>
f0101503:	85 c9                	test   %ecx,%ecx
f0101505:	75 0b                	jne    f0101512 <__udivdi3+0x32>
f0101507:	b8 01 00 00 00       	mov    $0x1,%eax
f010150c:	31 d2                	xor    %edx,%edx
f010150e:	f7 f1                	div    %ecx
f0101510:	89 c1                	mov    %eax,%ecx
f0101512:	89 f8                	mov    %edi,%eax
f0101514:	31 d2                	xor    %edx,%edx
f0101516:	f7 f1                	div    %ecx
f0101518:	89 c7                	mov    %eax,%edi
f010151a:	89 f0                	mov    %esi,%eax
f010151c:	f7 f1                	div    %ecx
f010151e:	89 fa                	mov    %edi,%edx
f0101520:	89 c6                	mov    %eax,%esi
f0101522:	89 75 f0             	mov    %esi,-0x10(%ebp)
f0101525:	89 55 f4             	mov    %edx,-0xc(%ebp)
f0101528:	8b 45 f0             	mov    -0x10(%ebp),%eax
f010152b:	8b 55 f4             	mov    -0xc(%ebp),%edx
f010152e:	8d 64 24 20          	lea    0x20(%esp),%esp
f0101532:	5e                   	pop    %esi
f0101533:	5f                   	pop    %edi
f0101534:	5d                   	pop    %ebp
f0101535:	c3                   	ret    
f0101536:	66 90                	xchg   %ax,%ax
f0101538:	31 d2                	xor    %edx,%edx
f010153a:	31 f6                	xor    %esi,%esi
f010153c:	39 f8                	cmp    %edi,%eax
f010153e:	77 e2                	ja     f0101522 <__udivdi3+0x42>
f0101540:	0f bd d0             	bsr    %eax,%edx
f0101543:	83 f2 1f             	xor    $0x1f,%edx
f0101546:	89 55 ec             	mov    %edx,-0x14(%ebp)
f0101549:	75 2d                	jne    f0101578 <__udivdi3+0x98>
f010154b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
f010154e:	39 4d f0             	cmp    %ecx,-0x10(%ebp)
f0101551:	76 06                	jbe    f0101559 <__udivdi3+0x79>
f0101553:	39 f8                	cmp    %edi,%eax
f0101555:	89 f2                	mov    %esi,%edx
f0101557:	73 c9                	jae    f0101522 <__udivdi3+0x42>
f0101559:	31 d2                	xor    %edx,%edx
f010155b:	be 01 00 00 00       	mov    $0x1,%esi
f0101560:	eb c0                	jmp    f0101522 <__udivdi3+0x42>
f0101562:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f0101568:	89 f0                	mov    %esi,%eax
f010156a:	89 fa                	mov    %edi,%edx
f010156c:	f7 f1                	div    %ecx
f010156e:	31 d2                	xor    %edx,%edx
f0101570:	89 c6                	mov    %eax,%esi
f0101572:	eb ae                	jmp    f0101522 <__udivdi3+0x42>
f0101574:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f0101578:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f010157c:	89 c2                	mov    %eax,%edx
f010157e:	b8 20 00 00 00       	mov    $0x20,%eax
f0101583:	2b 45 ec             	sub    -0x14(%ebp),%eax
f0101586:	d3 e2                	shl    %cl,%edx
f0101588:	89 c1                	mov    %eax,%ecx
f010158a:	8b 75 f0             	mov    -0x10(%ebp),%esi
f010158d:	d3 ee                	shr    %cl,%esi
f010158f:	09 d6                	or     %edx,%esi
f0101591:	89 fa                	mov    %edi,%edx
f0101593:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0101597:	89 75 e4             	mov    %esi,-0x1c(%ebp)
f010159a:	8b 75 f0             	mov    -0x10(%ebp),%esi
f010159d:	d3 e6                	shl    %cl,%esi
f010159f:	89 c1                	mov    %eax,%ecx
f01015a1:	89 75 f0             	mov    %esi,-0x10(%ebp)
f01015a4:	8b 75 e8             	mov    -0x18(%ebp),%esi
f01015a7:	d3 ea                	shr    %cl,%edx
f01015a9:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f01015ad:	d3 e7                	shl    %cl,%edi
f01015af:	89 c1                	mov    %eax,%ecx
f01015b1:	d3 ee                	shr    %cl,%esi
f01015b3:	09 fe                	or     %edi,%esi
f01015b5:	89 f0                	mov    %esi,%eax
f01015b7:	f7 75 e4             	divl   -0x1c(%ebp)
f01015ba:	89 d7                	mov    %edx,%edi
f01015bc:	89 c6                	mov    %eax,%esi
f01015be:	f7 65 f0             	mull   -0x10(%ebp)
f01015c1:	39 d7                	cmp    %edx,%edi
f01015c3:	89 55 e4             	mov    %edx,-0x1c(%ebp)
f01015c6:	72 12                	jb     f01015da <__udivdi3+0xfa>
f01015c8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f01015cc:	8b 55 e8             	mov    -0x18(%ebp),%edx
f01015cf:	d3 e2                	shl    %cl,%edx
f01015d1:	39 c2                	cmp    %eax,%edx
f01015d3:	73 08                	jae    f01015dd <__udivdi3+0xfd>
f01015d5:	3b 7d e4             	cmp    -0x1c(%ebp),%edi
f01015d8:	75 03                	jne    f01015dd <__udivdi3+0xfd>
f01015da:	8d 76 ff             	lea    -0x1(%esi),%esi
f01015dd:	31 d2                	xor    %edx,%edx
f01015df:	e9 3e ff ff ff       	jmp    f0101522 <__udivdi3+0x42>
f01015e4:	47                   	inc    %edi
f01015e5:	43                   	inc    %ebx
f01015e6:	43                   	inc    %ebx
f01015e7:	3a 20                	cmp    (%eax),%ah
f01015e9:	28 47 4e             	sub    %al,0x4e(%edi)
f01015ec:	55                   	push   %ebp
f01015ed:	29 20                	sub    %esp,(%eax)
f01015ef:	34 2e                	xor    $0x2e,%al
f01015f1:	35 2e 31 20 32       	xor    $0x3220312e,%eax
f01015f6:	30 31                	xor    %dh,(%ecx)
f01015f8:	30 30                	xor    %dh,(%eax)
f01015fa:	39 32                	cmp    %esi,(%edx)
f01015fc:	34 20                	xor    $0x20,%al
f01015fe:	28 52 65             	sub    %dl,0x65(%edx)
f0101601:	64 20 48 61          	and    %cl,%fs:0x61(%eax)
f0101605:	74 20                	je     f0101627 <__udivdi3+0x147>
f0101607:	34 2e                	xor    $0x2e,%al
f0101609:	35 2e 31 2d 34       	xor    $0x342d312e,%eax
f010160e:	29 00                	sub    %eax,(%eax)
f0101610:	14 00                	adc    $0x0,%al
f0101612:	00 00                	add    %al,(%eax)
f0101614:	00 00                	add    %al,(%eax)
f0101616:	00 00                	add    %al,(%eax)
f0101618:	01 7a 52             	add    %edi,0x52(%edx)
f010161b:	00 01                	add    %al,(%ecx)
f010161d:	7c 08                	jl     f0101627 <__udivdi3+0x147>
f010161f:	01 1b                	add    %ebx,(%ebx)
f0101621:	0c 04                	or     $0x4,%al
f0101623:	04 88                	add    $0x88,%al
f0101625:	01 00                	add    %eax,(%eax)
f0101627:	00 28                	add    %ch,(%eax)
f0101629:	00 00                	add    %al,(%eax)
f010162b:	00 1c 00             	add    %bl,(%eax,%eax,1)
f010162e:	00 00                	add    %al,(%eax)
f0101630:	b0 fe                	mov    $0xfe,%al
f0101632:	ff                   	(bad)  
f0101633:	ff 04 01             	incl   (%ecx,%eax,1)
f0101636:	00 00                	add    %al,(%eax)
f0101638:	00 41 0e             	add    %al,0xe(%ecx)
f010163b:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
f0101641:	4c                   	dec    %esp
f0101642:	86 04 87             	xchg   %al,(%edi,%eax,4)
f0101645:	03 02                	add    (%edx),%eax
f0101647:	44                   	inc    %esp
f0101648:	0a c6                	or     %dh,%al
f010164a:	41                   	inc    %ecx
f010164b:	c7 41 c5 0c 04 04 43 	movl   $0x4304040c,-0x3b(%ecx)
f0101652:	0b 00                	or     (%eax),%eax
	...

f0101660 <__umoddi3>:
f0101660:	55                   	push   %ebp
f0101661:	89 e5                	mov    %esp,%ebp
f0101663:	57                   	push   %edi
f0101664:	56                   	push   %esi
f0101665:	8d 64 24 e0          	lea    -0x20(%esp),%esp
f0101669:	8b 7d 14             	mov    0x14(%ebp),%edi
f010166c:	8b 45 08             	mov    0x8(%ebp),%eax
f010166f:	8b 4d 10             	mov    0x10(%ebp),%ecx
f0101672:	8b 75 0c             	mov    0xc(%ebp),%esi
f0101675:	85 ff                	test   %edi,%edi
f0101677:	89 45 e8             	mov    %eax,-0x18(%ebp)
f010167a:	89 4d f4             	mov    %ecx,-0xc(%ebp)
f010167d:	89 45 f0             	mov    %eax,-0x10(%ebp)
f0101680:	89 f2                	mov    %esi,%edx
f0101682:	75 14                	jne    f0101698 <__umoddi3+0x38>
f0101684:	39 f1                	cmp    %esi,%ecx
f0101686:	76 40                	jbe    f01016c8 <__umoddi3+0x68>
f0101688:	f7 f1                	div    %ecx
f010168a:	89 d0                	mov    %edx,%eax
f010168c:	31 d2                	xor    %edx,%edx
f010168e:	8d 64 24 20          	lea    0x20(%esp),%esp
f0101692:	5e                   	pop    %esi
f0101693:	5f                   	pop    %edi
f0101694:	5d                   	pop    %ebp
f0101695:	c3                   	ret    
f0101696:	66 90                	xchg   %ax,%ax
f0101698:	39 f7                	cmp    %esi,%edi
f010169a:	77 4c                	ja     f01016e8 <__umoddi3+0x88>
f010169c:	0f bd c7             	bsr    %edi,%eax
f010169f:	83 f0 1f             	xor    $0x1f,%eax
f01016a2:	89 45 ec             	mov    %eax,-0x14(%ebp)
f01016a5:	75 51                	jne    f01016f8 <__umoddi3+0x98>
f01016a7:	3b 4d f0             	cmp    -0x10(%ebp),%ecx
f01016aa:	0f 87 e8 00 00 00    	ja     f0101798 <__umoddi3+0x138>
f01016b0:	89 f2                	mov    %esi,%edx
f01016b2:	8b 75 f0             	mov    -0x10(%ebp),%esi
f01016b5:	29 ce                	sub    %ecx,%esi
f01016b7:	19 fa                	sbb    %edi,%edx
f01016b9:	89 75 f0             	mov    %esi,-0x10(%ebp)
f01016bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01016bf:	8d 64 24 20          	lea    0x20(%esp),%esp
f01016c3:	5e                   	pop    %esi
f01016c4:	5f                   	pop    %edi
f01016c5:	5d                   	pop    %ebp
f01016c6:	c3                   	ret    
f01016c7:	90                   	nop
f01016c8:	85 c9                	test   %ecx,%ecx
f01016ca:	75 0b                	jne    f01016d7 <__umoddi3+0x77>
f01016cc:	b8 01 00 00 00       	mov    $0x1,%eax
f01016d1:	31 d2                	xor    %edx,%edx
f01016d3:	f7 f1                	div    %ecx
f01016d5:	89 c1                	mov    %eax,%ecx
f01016d7:	89 f0                	mov    %esi,%eax
f01016d9:	31 d2                	xor    %edx,%edx
f01016db:	f7 f1                	div    %ecx
f01016dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
f01016e0:	f7 f1                	div    %ecx
f01016e2:	eb a6                	jmp    f010168a <__umoddi3+0x2a>
f01016e4:	8d 74 26 00          	lea    0x0(%esi,%eiz,1),%esi
f01016e8:	89 f2                	mov    %esi,%edx
f01016ea:	8d 64 24 20          	lea    0x20(%esp),%esp
f01016ee:	5e                   	pop    %esi
f01016ef:	5f                   	pop    %edi
f01016f0:	5d                   	pop    %ebp
f01016f1:	c3                   	ret    
f01016f2:	8d b6 00 00 00 00    	lea    0x0(%esi),%esi
f01016f8:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f01016fc:	c7 45 f0 20 00 00 00 	movl   $0x20,-0x10(%ebp)
f0101703:	8b 45 ec             	mov    -0x14(%ebp),%eax
f0101706:	29 45 f0             	sub    %eax,-0x10(%ebp)
f0101709:	d3 e7                	shl    %cl,%edi
f010170b:	8b 45 f4             	mov    -0xc(%ebp),%eax
f010170e:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101712:	89 f2                	mov    %esi,%edx
f0101714:	d3 e8                	shr    %cl,%eax
f0101716:	09 f8                	or     %edi,%eax
f0101718:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f010171c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
f010171f:	8b 45 f4             	mov    -0xc(%ebp),%eax
f0101722:	d3 e0                	shl    %cl,%eax
f0101724:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101728:	89 45 f4             	mov    %eax,-0xc(%ebp)
f010172b:	8b 45 e8             	mov    -0x18(%ebp),%eax
f010172e:	d3 ea                	shr    %cl,%edx
f0101730:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0101734:	d3 e6                	shl    %cl,%esi
f0101736:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f010173a:	d3 e8                	shr    %cl,%eax
f010173c:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f0101740:	09 f0                	or     %esi,%eax
f0101742:	8b 75 e8             	mov    -0x18(%ebp),%esi
f0101745:	d3 e6                	shl    %cl,%esi
f0101747:	f7 75 e4             	divl   -0x1c(%ebp)
f010174a:	89 75 e8             	mov    %esi,-0x18(%ebp)
f010174d:	89 d6                	mov    %edx,%esi
f010174f:	f7 65 f4             	mull   -0xc(%ebp)
f0101752:	89 d7                	mov    %edx,%edi
f0101754:	89 c2                	mov    %eax,%edx
f0101756:	39 fe                	cmp    %edi,%esi
f0101758:	89 f9                	mov    %edi,%ecx
f010175a:	72 30                	jb     f010178c <__umoddi3+0x12c>
f010175c:	39 45 e8             	cmp    %eax,-0x18(%ebp)
f010175f:	72 27                	jb     f0101788 <__umoddi3+0x128>
f0101761:	8b 45 e8             	mov    -0x18(%ebp),%eax
f0101764:	29 d0                	sub    %edx,%eax
f0101766:	19 ce                	sbb    %ecx,%esi
f0101768:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f010176c:	89 f2                	mov    %esi,%edx
f010176e:	d3 e8                	shr    %cl,%eax
f0101770:	0f b6 4d f0          	movzbl -0x10(%ebp),%ecx
f0101774:	d3 e2                	shl    %cl,%edx
f0101776:	0f b6 4d ec          	movzbl -0x14(%ebp),%ecx
f010177a:	09 d0                	or     %edx,%eax
f010177c:	89 f2                	mov    %esi,%edx
f010177e:	d3 ea                	shr    %cl,%edx
f0101780:	8d 64 24 20          	lea    0x20(%esp),%esp
f0101784:	5e                   	pop    %esi
f0101785:	5f                   	pop    %edi
f0101786:	5d                   	pop    %ebp
f0101787:	c3                   	ret    
f0101788:	39 fe                	cmp    %edi,%esi
f010178a:	75 d5                	jne    f0101761 <__umoddi3+0x101>
f010178c:	89 f9                	mov    %edi,%ecx
f010178e:	89 c2                	mov    %eax,%edx
f0101790:	2b 55 f4             	sub    -0xc(%ebp),%edx
f0101793:	1b 4d e4             	sbb    -0x1c(%ebp),%ecx
f0101796:	eb c9                	jmp    f0101761 <__umoddi3+0x101>
f0101798:	39 f7                	cmp    %esi,%edi
f010179a:	0f 82 10 ff ff ff    	jb     f01016b0 <__umoddi3+0x50>
f01017a0:	e9 17 ff ff ff       	jmp    f01016bc <__umoddi3+0x5c>
f01017a5:	00 00                	add    %al,(%eax)
f01017a7:	00 4c 00 00          	add    %cl,0x0(%eax,%eax,1)
f01017ab:	00 9c 01 00 00 b0 fe 	add    %bl,-0x1500000(%ecx,%eax,1)
f01017b2:	ff                   	(bad)  
f01017b3:	ff 45 01             	incl   0x1(%ebp)
f01017b6:	00 00                	add    %al,(%eax)
f01017b8:	00 41 0e             	add    %al,0xe(%ecx)
f01017bb:	08 85 02 42 0d 05    	or     %al,0x50d4202(%ebp)
f01017c1:	49                   	dec    %ecx
f01017c2:	86 04 87             	xchg   %al,(%edi,%eax,4)
f01017c5:	03 67 0a             	add    0xa(%edi),%esp
f01017c8:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
f01017cc:	c5 0c 04             	lds    (%esp,%eax,1),%ecx
f01017cf:	04 43                	add    $0x43,%al
f01017d1:	0b 6c 0a c6          	or     -0x3a(%edx,%ecx,1),%ebp
f01017d5:	41                   	inc    %ecx
f01017d6:	c7 41 0c 04 04 c5 42 	movl   $0x42c50404,0xc(%ecx)
f01017dd:	0b 67 0a             	or     0xa(%edi),%esp
f01017e0:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
f01017e4:	0c 04                	or     $0x4,%al
f01017e6:	04 c5                	add    $0xc5,%al
f01017e8:	47                   	inc    %edi
f01017e9:	0b 02                	or     (%edx),%eax
f01017eb:	8d 0a                	lea    (%edx),%ecx
f01017ed:	c6 41 c7 41          	movb   $0x41,-0x39(%ecx)
f01017f1:	0c 04                	or     $0x4,%al
f01017f3:	04 c5                	add    $0xc5,%al
f01017f5:	41                   	inc    %ecx
f01017f6:	0b 00                	or     (%eax),%eax

f01017f8 <UTEXT_end>:
.global entry
_start = RELOC(entry)

.text
entry:
	movw	$0x1234,0x472			# warm boot
f01017f8:	66 c7 05 72 04 00 00 	movw   $0x1234,0x472
f01017ff:	34 12 
	# KERNBASE+1MB.  Hence, we set up a trivial page directory that
	# translates virtual addresses [KERNBASE, KERNBASE+4MB) to
	# physical addresses [0, 4MB).  This 4MB region will be
	# sufficient until we set up our real page table in mem_init.

    movl $0, %eax
f0101801:	b8 00 00 00 00       	mov    $0x0,%eax
    movl $(RELOC(bss_start)), %edi
f0101806:	bf 3c a0 10 00       	mov    $0x10a03c,%edi
    movl $(RELOC(end)), %ecx
f010180b:	b9 58 7a 11 00       	mov    $0x117a58,%ecx
    subl %edi, %ecx
f0101810:	29 f9                	sub    %edi,%ecx
    cld
f0101812:	fc                   	cld    
    rep stosb
f0101813:	f3 aa                	rep stos %al,%es:(%edi)

	# Load the physical address of entry_pgdir into cr3.  entry_pgdir
	# is defined in entrypgdir.c.
	movl	$(RELOC(entry_pgdir)), %eax
f0101815:	b8 00 80 10 00       	mov    $0x108000,%eax
	movl	%eax, %cr3
f010181a:	0f 22 d8             	mov    %eax,%cr3
	# Turn on paging.
	movl	%cr0, %eax
f010181d:	0f 20 c0             	mov    %cr0,%eax
	orl	$(CR0_PE|CR0_PG|CR0_WP), %eax
f0101820:	0d 01 00 01 80       	or     $0x80010001,%eax
	movl	%eax, %cr0
f0101825:	0f 22 c0             	mov    %eax,%cr0

	# Now paging is enabled, but we're still running at a low EIP
	# (why is this okay?).  Jump up above KERNBASE before entering
	# C code.
	mov	$relocated, %eax
f0101828:	b8 2f 18 10 f0       	mov    $0xf010182f,%eax
	jmp	*%eax
f010182d:	ff e0                	jmp    *%eax

f010182f <relocated>:

relocated:

  # Setup new gdt
  lgdt    kgdtdesc
f010182f:	0f 01 15 60 18 10 f0 	lgdtl  0xf0101860

	# Setup kernel stack
	movl $0, %ebp
f0101836:	bd 00 00 00 00       	mov    $0x0,%ebp
	movl $(bootstacktop), %esp
f010183b:	bc 00 40 11 f0       	mov    $0xf0114000,%esp

	call kernel_main
f0101840:	e8 23 00 00 00       	call   f0101868 <kernel_main>

f0101845 <die>:
die:
	jmp die
f0101845:	eb fe                	jmp    f0101845 <die>
f0101847:	90                   	nop

f0101848 <kgdt>:
	...
f0101850:	ff                   	(bad)  
f0101851:	ff 00                	incl   (%eax)
f0101853:	00 00                	add    %al,(%eax)
f0101855:	9a cf 00 ff ff 00 00 	lcall  $0x0,$0xffff00cf
f010185c:	00 92 cf 00 17 00    	add    %dl,0x1700cf(%edx)

f0101860 <kgdtdesc>:
f0101860:	17                   	pop    %ss
f0101861:	00 48 18             	add    %cl,0x18(%eax)
f0101864:	10 f0                	adc    %dh,%al
	...

f0101868 <kernel_main>:

extern void init_video(void);
extern Task *cur_task;

void kernel_main(void)
{
f0101868:	83 ec 0c             	sub    $0xc,%esp
	extern char stext[];
	extern char etext[], end[], data_start[],rdata_end[];
	extern void task_job();

	init_video();
f010186b:	e8 bd 04 00 00       	call   f0101d2d <init_video>

	trap_init();
f0101870:	e8 f2 07 00 00       	call   f0102067 <trap_init>
	pic_init();
f0101875:	e8 c2 00 00 00       	call   f010193c <pic_init>
	kbd_init();
f010187a:	e8 65 02 00 00       	call   f0101ae4 <kbd_init>
     mem_init();
f010187f:	e8 8c 0f 00 00       	call   f0102810 <mem_init>

  printk("Kernel code base start=0x%08x to = 0x%08x\n", stext, etext);
f0101884:	50                   	push   %eax
f0101885:	68 9e 43 10 f0       	push   $0xf010439e
f010188a:	68 00 00 10 f0       	push   $0xf0100000
f010188f:	68 44 54 10 f0       	push   $0xf0105444
f0101894:	e8 37 09 00 00       	call   f01021d0 <printk>
  printk("Readonly data start=0x%08x to = 0x%08x\n", etext, rdata_end);
f0101899:	83 c4 0c             	add    $0xc,%esp
f010189c:	68 b3 65 10 f0       	push   $0xf01065b3
f01018a1:	68 9e 43 10 f0       	push   $0xf010439e
f01018a6:	68 6f 54 10 f0       	push   $0xf010546f
f01018ab:	e8 20 09 00 00       	call   f01021d0 <printk>
  printk("Kernel data base start=0x%08x to = 0x%08x\n", data_start, end);
f01018b0:	83 c4 0c             	add    $0xc,%esp
f01018b3:	68 58 7a 11 f0       	push   $0xf0117a58
f01018b8:	68 00 70 10 f0       	push   $0xf0107000
f01018bd:	68 97 54 10 f0       	push   $0xf0105497
f01018c2:	e8 09 09 00 00       	call   f01021d0 <printk>
  timer_init();
f01018c7:	e8 51 24 00 00       	call   f0103d1d <timer_init>
  syscall_init();
f01018cc:	e8 f0 29 00 00       	call   f01042c1 <syscall_init>

  task_init();
f01018d1:	e8 72 27 00 00       	call   f0104048 <task_init>
  /* Enable interrupt */
  __asm __volatile("sti");
f01018d6:	fb                   	sti    

  lcr3(PADDR(cur_task->pgdir));
f01018d7:	8b 15 2c 4e 11 f0    	mov    0xf0114e2c,%edx
/* -------------- Inline Functions --------------  */

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f01018dd:	83 c4 10             	add    $0x10,%esp
f01018e0:	8b 42 54             	mov    0x54(%edx),%eax
f01018e3:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f01018e8:	77 12                	ja     f01018fc <kernel_main+0x94>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f01018ea:	50                   	push   %eax
f01018eb:	68 c2 54 10 f0       	push   $0xf01054c2
f01018f0:	6a 26                	push   $0x26
f01018f2:	68 e6 54 10 f0       	push   $0xf01054e6
f01018f7:	e8 ec 22 00 00       	call   f0103be8 <_panic>
	return (physaddr_t)kva - KERNBASE;
f01018fc:	05 00 00 00 10       	add    $0x10000000,%eax
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0101901:	0f 22 d8             	mov    %eax,%cr3
  /* Move to user mode */
  asm volatile("movl %0,%%eax\n\t" \
f0101904:	8b 42 44             	mov    0x44(%edx),%eax
f0101907:	6a 23                	push   $0x23
f0101909:	50                   	push   %eax
f010190a:	9c                   	pushf  
f010190b:	6a 1b                	push   $0x1b
f010190d:	ff 72 38             	pushl  0x38(%edx)
f0101910:	cf                   	iret   
  "pushl %2\n\t" \
  "pushl %3\n\t" \
  "iret\n" \
  :: "m" (cur_task->tf.tf_esp), "i" (GD_UD | 0x03), "i" (GD_UT | 0x03), "m" (cur_task->tf.tf_eip)
  :"ax");
}
f0101911:	83 c4 0c             	add    $0xc,%esp
f0101914:	c3                   	ret    
f0101915:	00 00                	add    %al,(%eax)
	...

f0101918 <irq_setmask_8259A>:
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f0101918:	8b 54 24 04          	mov    0x4(%esp),%edx
	irq_mask_8259A = mask;
	if (!didinit)
f010191c:	80 3d 00 40 11 f0 00 	cmpb   $0x0,0xf0114000
		irq_setmask_8259A(irq_mask_8259A);
}

void
irq_setmask_8259A(uint16_t mask)
{
f0101923:	89 d0                	mov    %edx,%eax
	irq_mask_8259A = mask;
f0101925:	66 89 15 3c 70 10 f0 	mov    %dx,0xf010703c
	if (!didinit)
f010192c:	74 0d                	je     f010193b <irq_setmask_8259A+0x23>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f010192e:	ba 21 00 00 00       	mov    $0x21,%edx
f0101933:	ee                   	out    %al,(%dx)
		return;
	outb(IO_PIC1+1, (char)mask);
	outb(IO_PIC2+1, (char)(mask >> 8));
f0101934:	66 c1 e8 08          	shr    $0x8,%ax
f0101938:	b2 a1                	mov    $0xa1,%dl
f010193a:	ee                   	out    %al,(%dx)
f010193b:	c3                   	ret    

f010193c <pic_init>:
static bool didinit;

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
f010193c:	57                   	push   %edi
f010193d:	b9 21 00 00 00       	mov    $0x21,%ecx
f0101942:	56                   	push   %esi
f0101943:	b0 ff                	mov    $0xff,%al
f0101945:	53                   	push   %ebx
f0101946:	89 ca                	mov    %ecx,%edx
f0101948:	ee                   	out    %al,(%dx)
f0101949:	be a1 00 00 00       	mov    $0xa1,%esi
f010194e:	89 f2                	mov    %esi,%edx
f0101950:	ee                   	out    %al,(%dx)
f0101951:	bf 11 00 00 00       	mov    $0x11,%edi
f0101956:	bb 20 00 00 00       	mov    $0x20,%ebx
f010195b:	89 f8                	mov    %edi,%eax
f010195d:	89 da                	mov    %ebx,%edx
f010195f:	ee                   	out    %al,(%dx)
f0101960:	b0 20                	mov    $0x20,%al
f0101962:	89 ca                	mov    %ecx,%edx
f0101964:	ee                   	out    %al,(%dx)
f0101965:	b0 04                	mov    $0x4,%al
f0101967:	ee                   	out    %al,(%dx)
f0101968:	b0 03                	mov    $0x3,%al
f010196a:	ee                   	out    %al,(%dx)
f010196b:	b1 a0                	mov    $0xa0,%cl
f010196d:	89 f8                	mov    %edi,%eax
f010196f:	89 ca                	mov    %ecx,%edx
f0101971:	ee                   	out    %al,(%dx)
f0101972:	b0 28                	mov    $0x28,%al
f0101974:	89 f2                	mov    %esi,%edx
f0101976:	ee                   	out    %al,(%dx)
f0101977:	b0 02                	mov    $0x2,%al
f0101979:	ee                   	out    %al,(%dx)
f010197a:	b0 01                	mov    $0x1,%al
f010197c:	ee                   	out    %al,(%dx)
f010197d:	bf 68 00 00 00       	mov    $0x68,%edi
f0101982:	89 da                	mov    %ebx,%edx
f0101984:	89 f8                	mov    %edi,%eax
f0101986:	ee                   	out    %al,(%dx)
f0101987:	be 0a 00 00 00       	mov    $0xa,%esi
f010198c:	89 f0                	mov    %esi,%eax
f010198e:	ee                   	out    %al,(%dx)
f010198f:	89 f8                	mov    %edi,%eax
f0101991:	89 ca                	mov    %ecx,%edx
f0101993:	ee                   	out    %al,(%dx)
f0101994:	89 f0                	mov    %esi,%eax
f0101996:	ee                   	out    %al,(%dx)
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);               /* OCW3 */
	outb(IO_PIC2, 0x0a);               /* OCW3 */

	if (irq_mask_8259A != 0xFFFF)
f0101997:	66 a1 3c 70 10 f0    	mov    0xf010703c,%ax

/* Initialize the 8259A interrupt controllers. */
void
pic_init(void)
{
	didinit = 1;
f010199d:	c6 05 00 40 11 f0 01 	movb   $0x1,0xf0114000
	outb(IO_PIC1, 0x0a);             /* read IRR by default */

	outb(IO_PIC2, 0x68);               /* OCW3 */
	outb(IO_PIC2, 0x0a);               /* OCW3 */

	if (irq_mask_8259A != 0xFFFF)
f01019a4:	66 83 f8 ff          	cmp    $0xffffffff,%ax
f01019a8:	74 0a                	je     f01019b4 <pic_init+0x78>
		irq_setmask_8259A(irq_mask_8259A);
f01019aa:	0f b7 c0             	movzwl %ax,%eax
f01019ad:	50                   	push   %eax
f01019ae:	e8 65 ff ff ff       	call   f0101918 <irq_setmask_8259A>
f01019b3:	58                   	pop    %eax
}
f01019b4:	5b                   	pop    %ebx
f01019b5:	5e                   	pop    %esi
f01019b6:	5f                   	pop    %edi
f01019b7:	c3                   	ret    

f01019b8 <kbd_proc_data>:
 * Get data from the keyboard.  If we finish a character, return it.  Else 0.
 * Return -1 if no data.
 */
static int
kbd_proc_data(void)
{
f01019b8:	53                   	push   %ebx

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f01019b9:	ba 64 00 00 00       	mov    $0x64,%edx
f01019be:	83 ec 08             	sub    $0x8,%esp
f01019c1:	ec                   	in     (%dx),%al
  int c;
  uint8_t data;
  static uint32_t shift;

  if ((inb(KBSTATP) & KBS_DIB) == 0)
    return -1;
f01019c2:	83 c9 ff             	or     $0xffffffff,%ecx
{
  int c;
  uint8_t data;
  static uint32_t shift;

  if ((inb(KBSTATP) & KBS_DIB) == 0)
f01019c5:	a8 01                	test   $0x1,%al
f01019c7:	0f 84 ae 00 00 00    	je     f0101a7b <kbd_proc_data+0xc3>
f01019cd:	b2 60                	mov    $0x60,%dl
f01019cf:	ec                   	in     (%dx),%al
    return -1;

  data = inb(KBDATAP);

  if (data == 0xE0) {
f01019d0:	3c e0                	cmp    $0xe0,%al
f01019d2:	88 c1                	mov    %al,%cl
f01019d4:	75 12                	jne    f01019e8 <kbd_proc_data+0x30>
f01019d6:	ec                   	in     (%dx),%al
    data = inb(KBDATAP);
    if (data & 0x80)
      return 0;
f01019d7:	31 c9                	xor    %ecx,%ecx

  data = inb(KBDATAP);

  if (data == 0xE0) {
    data = inb(KBDATAP);
    if (data & 0x80)
f01019d9:	84 c0                	test   %al,%al
f01019db:	0f 88 9a 00 00 00    	js     f0101a7b <kbd_proc_data+0xc3>
      return 0;
    else
      data |= 0x80;
f01019e1:	88 c1                	mov    %al,%cl
f01019e3:	83 c9 80             	or     $0xffffff80,%ecx
f01019e6:	eb 1a                	jmp    f0101a02 <kbd_proc_data+0x4a>
  } else if (data & 0x80) {
f01019e8:	84 c0                	test   %al,%al
f01019ea:	79 16                	jns    f0101a02 <kbd_proc_data+0x4a>
    // Key released
    data &= 0x7F;
    shift &= ~(shiftcode[data]);
f01019ec:	83 e0 7f             	and    $0x7f,%eax
    return 0;
f01019ef:	31 c9                	xor    %ecx,%ecx
    else
      data |= 0x80;
  } else if (data & 0x80) {
    // Key released
    data &= 0x7F;
    shift &= ~(shiftcode[data]);
f01019f1:	0f b6 80 00 55 10 f0 	movzbl -0xfefab00(%eax),%eax
f01019f8:	f7 d0                	not    %eax
f01019fa:	21 05 0c 42 11 f0    	and    %eax,0xf011420c
    return 0;
f0101a00:	eb 79                	jmp    f0101a7b <kbd_proc_data+0xc3>
  }

  shift |= shiftcode[data];
f0101a02:	0f b6 c1             	movzbl %cl,%eax
  shift ^= togglecode[data];
f0101a05:	0f b6 90 00 56 10 f0 	movzbl -0xfefaa00(%eax),%edx
    data &= 0x7F;
    shift &= ~(shiftcode[data]);
    return 0;
  }

  shift |= shiftcode[data];
f0101a0c:	0f b6 98 00 55 10 f0 	movzbl -0xfefab00(%eax),%ebx
f0101a13:	0b 1d 0c 42 11 f0    	or     0xf011420c,%ebx
  shift ^= togglecode[data];
f0101a19:	31 d3                	xor    %edx,%ebx

  c = charcode[shift & (CTL | SHIFT)][data];
f0101a1b:	89 da                	mov    %ebx,%edx
f0101a1d:	83 e2 03             	and    $0x3,%edx
  if (shift & CAPSLOCK) {
f0101a20:	f6 c3 08             	test   $0x8,%bl
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];

  c = charcode[shift & (CTL | SHIFT)][data];
f0101a23:	8b 14 95 00 57 10 f0 	mov    -0xfefa900(,%edx,4),%edx
    shift &= ~(shiftcode[data]);
    return 0;
  }

  shift |= shiftcode[data];
  shift ^= togglecode[data];
f0101a2a:	89 1d 0c 42 11 f0    	mov    %ebx,0xf011420c

  c = charcode[shift & (CTL | SHIFT)][data];
f0101a30:	0f b6 0c 02          	movzbl (%edx,%eax,1),%ecx
  if (shift & CAPSLOCK) {
f0101a34:	74 19                	je     f0101a4f <kbd_proc_data+0x97>
    if ('a' <= c && c <= 'z')
f0101a36:	8d 41 9f             	lea    -0x61(%ecx),%eax
f0101a39:	83 f8 19             	cmp    $0x19,%eax
f0101a3c:	77 05                	ja     f0101a43 <kbd_proc_data+0x8b>
      c += 'A' - 'a';
f0101a3e:	83 e9 20             	sub    $0x20,%ecx
f0101a41:	eb 0c                	jmp    f0101a4f <kbd_proc_data+0x97>
    else if ('A' <= c && c <= 'Z')
f0101a43:	8d 51 bf             	lea    -0x41(%ecx),%edx
      c += 'a' - 'A';
f0101a46:	8d 41 20             	lea    0x20(%ecx),%eax
f0101a49:	83 fa 19             	cmp    $0x19,%edx
f0101a4c:	0f 46 c8             	cmovbe %eax,%ecx
  }

  // Process special keys
  // Ctrl-Alt-Del: reboot
  if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
f0101a4f:	81 f9 e9 00 00 00    	cmp    $0xe9,%ecx
f0101a55:	75 24                	jne    f0101a7b <kbd_proc_data+0xc3>
f0101a57:	f7 d3                	not    %ebx
f0101a59:	80 e3 06             	and    $0x6,%bl
f0101a5c:	75 1d                	jne    f0101a7b <kbd_proc_data+0xc3>
    printk("Rebooting!\n");
f0101a5e:	83 ec 0c             	sub    $0xc,%esp
f0101a61:	68 f4 54 10 f0       	push   $0xf01054f4
f0101a66:	e8 65 07 00 00       	call   f01021d0 <printk>
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0101a6b:	ba 92 00 00 00       	mov    $0x92,%edx
f0101a70:	b0 03                	mov    $0x3,%al
f0101a72:	ee                   	out    %al,(%dx)
f0101a73:	b9 e9 00 00 00       	mov    $0xe9,%ecx
f0101a78:	83 c4 10             	add    $0x10,%esp
    outb(0x92, 0x3); // courtesy of Chris Frost
  }

  return c;
}
f0101a7b:	89 c8                	mov    %ecx,%eax
f0101a7d:	83 c4 08             	add    $0x8,%esp
f0101a80:	5b                   	pop    %ebx
f0101a81:	c3                   	ret    

f0101a82 <kbd_intr>:
/* 
 *  Note: The interrupt handler
 */
void
kbd_intr(struct Trapframe *tf)
{
f0101a82:	83 ec 0c             	sub    $0xc,%esp
f0101a85:	eb 23                	jmp    f0101aaa <kbd_intr+0x28>
cons_intr(int (*proc)(void))
{
  int c;

  while ((c = (*proc)()) != -1) {
    if (c == 0)
f0101a87:	85 c0                	test   %eax,%eax
f0101a89:	74 1f                	je     f0101aaa <kbd_intr+0x28>
      continue;

    cons.buf[cons.wpos++] = c;
f0101a8b:	8b 15 08 42 11 f0    	mov    0xf0114208,%edx
f0101a91:	88 82 04 40 11 f0    	mov    %al,-0xfeebffc(%edx)
f0101a97:	42                   	inc    %edx
    if (cons.wpos == CONSBUFSIZE)
      cons.wpos = 0;
f0101a98:	31 c0                	xor    %eax,%eax
f0101a9a:	81 fa 00 02 00 00    	cmp    $0x200,%edx
f0101aa0:	0f 45 c2             	cmovne %edx,%eax
f0101aa3:	a3 08 42 11 f0       	mov    %eax,0xf0114208
f0101aa8:	eb 0a                	jmp    f0101ab4 <kbd_intr+0x32>
  static void
cons_intr(int (*proc)(void))
{
  int c;

  while ((c = (*proc)()) != -1) {
f0101aaa:	e8 09 ff ff ff       	call   f01019b8 <kbd_proc_data>
f0101aaf:	83 f8 ff             	cmp    $0xffffffff,%eax
f0101ab2:	75 d3                	jne    f0101a87 <kbd_intr+0x5>
 */
void
kbd_intr(struct Trapframe *tf)
{
  cons_intr(kbd_proc_data);
}
f0101ab4:	83 c4 0c             	add    $0xc,%esp
f0101ab7:	c3                   	ret    

f0101ab8 <cons_getc>:
  // so that this function works even when interrupts are disabled
  // (e.g., when called from the kernel monitor).
  //kbd_intr();

  // grab the next character from the input buffer.
  if (cons.rpos != cons.wpos) {
f0101ab8:	8b 15 04 42 11 f0    	mov    0xf0114204,%edx
    c = cons.buf[cons.rpos++];
    if (cons.rpos == CONSBUFSIZE)
      cons.rpos = 0;
    return c;
  }
  return 0;
f0101abe:	31 c0                	xor    %eax,%eax
  // so that this function works even when interrupts are disabled
  // (e.g., when called from the kernel monitor).
  //kbd_intr();

  // grab the next character from the input buffer.
  if (cons.rpos != cons.wpos) {
f0101ac0:	3b 15 08 42 11 f0    	cmp    0xf0114208,%edx
f0101ac6:	74 1b                	je     f0101ae3 <cons_getc+0x2b>
    c = cons.buf[cons.rpos++];
f0101ac8:	8d 4a 01             	lea    0x1(%edx),%ecx
f0101acb:	0f b6 82 04 40 11 f0 	movzbl -0xfeebffc(%edx),%eax
    if (cons.rpos == CONSBUFSIZE)
      cons.rpos = 0;
f0101ad2:	31 d2                	xor    %edx,%edx
f0101ad4:	81 f9 00 02 00 00    	cmp    $0x200,%ecx
f0101ada:	0f 45 d1             	cmovne %ecx,%edx
f0101add:	89 15 04 42 11 f0    	mov    %edx,0xf0114204
    return c;
  }
  return 0;
}
f0101ae3:	c3                   	ret    

f0101ae4 <kbd_init>:
{
  cons_intr(kbd_proc_data);
}

void kbd_init(void)
{
f0101ae4:	83 ec 18             	sub    $0x18,%esp
  // Drain the kbd buffer so that Bochs generates interrupts.
  kbd_intr(NULL);
f0101ae7:	6a 00                	push   $0x0
f0101ae9:	e8 94 ff ff ff       	call   f0101a82 <kbd_intr>
  irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_KBD));
f0101aee:	0f b7 05 3c 70 10 f0 	movzwl 0xf010703c,%eax
f0101af5:	25 fd ff 00 00       	and    $0xfffd,%eax
f0101afa:	89 04 24             	mov    %eax,(%esp)
f0101afd:	e8 16 fe ff ff       	call   f0101918 <irq_setmask_8259A>
  /* Register trap handler */
  extern void KBD_Input();
  register_handler( IRQ_OFFSET + IRQ_KBD, &kbd_intr, &KBD_Input, 0, 0);
f0101b02:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0101b09:	6a 00                	push   $0x0
f0101b0b:	68 36 21 10 f0       	push   $0xf0102136
f0101b10:	68 82 1a 10 f0       	push   $0xf0101a82
f0101b15:	6a 21                	push   $0x21
f0101b17:	e8 29 04 00 00       	call   f0101f45 <register_handler>
}
f0101b1c:	83 c4 2c             	add    $0x2c,%esp
f0101b1f:	c3                   	ret    

f0101b20 <k_getc>:
int k_getc(void)
{
  // In lab4, our task is switched to user mode, so dont block at there
  //while ((c = cons_getc()) == 0)
  /* do nothing *///;
  return cons_getc();
f0101b20:	e9 93 ff ff ff       	jmp    f0101ab8 <cons_getc>
f0101b25:	00 00                	add    %al,(%eax)
	...

f0101b28 <scroll>:
int attrib = 0x0F;
int csr_x = 0, csr_y = 0;

/* Scrolls the screen */
void scroll(void)
{
f0101b28:	56                   	push   %esi
f0101b29:	53                   	push   %ebx
f0101b2a:	83 ec 04             	sub    $0x4,%esp
    /* A blank is defined as a space... we need to give it
    *  backcolor too */
    blank = 0x0 | (attrib << 8);

    /* Row 25 is the end, this means we need to scroll up */
    if(csr_y >= 25)
f0101b2d:	8b 1d 14 42 11 f0    	mov    0xf0114214,%ebx
{
    unsigned short blank, temp;

    /* A blank is defined as a space... we need to give it
    *  backcolor too */
    blank = 0x0 | (attrib << 8);
f0101b33:	8b 35 40 73 10 f0    	mov    0xf0107340,%esi

    /* Row 25 is the end, this means we need to scroll up */
    if(csr_y >= 25)
f0101b39:	83 fb 18             	cmp    $0x18,%ebx
f0101b3c:	7e 5b                	jle    f0101b99 <scroll+0x71>
    {
        /* Move the current text chunk that makes up the screen
        *  back in the buffer by a line */
        temp = csr_y - 25 + 1;
f0101b3e:	83 eb 18             	sub    $0x18,%ebx
        memcpy (textmemptr, textmemptr + temp * 80, (25 - temp) * 80 * 2);
f0101b41:	a1 c0 76 11 f0       	mov    0xf01176c0,%eax
f0101b46:	0f b7 db             	movzwl %bx,%ebx
f0101b49:	52                   	push   %edx
f0101b4a:	69 d3 60 ff ff ff    	imul   $0xffffff60,%ebx,%edx
{
    unsigned short blank, temp;

    /* A blank is defined as a space... we need to give it
    *  backcolor too */
    blank = 0x0 | (attrib << 8);
f0101b50:	c1 e6 08             	shl    $0x8,%esi
        temp = csr_y - 25 + 1;
        memcpy (textmemptr, textmemptr + temp * 80, (25 - temp) * 80 * 2);

        /* Finally, we set the chunk of memory that occupies
        *  the last line of text to our 'blank' character */
        memset (textmemptr + (25 - temp) * 80, blank, 80 * 2);
f0101b53:	0f b7 f6             	movzwl %si,%esi
    if(csr_y >= 25)
    {
        /* Move the current text chunk that makes up the screen
        *  back in the buffer by a line */
        temp = csr_y - 25 + 1;
        memcpy (textmemptr, textmemptr + temp * 80, (25 - temp) * 80 * 2);
f0101b56:	81 c2 a0 0f 00 00    	add    $0xfa0,%edx
f0101b5c:	52                   	push   %edx
f0101b5d:	69 d3 a0 00 00 00    	imul   $0xa0,%ebx,%edx

        /* Finally, we set the chunk of memory that occupies
        *  the last line of text to our 'blank' character */
        memset (textmemptr + (25 - temp) * 80, blank, 80 * 2);
f0101b63:	6b db b0             	imul   $0xffffffb0,%ebx,%ebx
    if(csr_y >= 25)
    {
        /* Move the current text chunk that makes up the screen
        *  back in the buffer by a line */
        temp = csr_y - 25 + 1;
        memcpy (textmemptr, textmemptr + temp * 80, (25 - temp) * 80 * 2);
f0101b66:	8d 14 10             	lea    (%eax,%edx,1),%edx
f0101b69:	52                   	push   %edx
f0101b6a:	50                   	push   %eax
f0101b6b:	e8 39 e7 ff ff       	call   f01002a9 <memcpy>

        /* Finally, we set the chunk of memory that occupies
        *  the last line of text to our 'blank' character */
        memset (textmemptr + (25 - temp) * 80, blank, 80 * 2);
f0101b70:	83 c4 0c             	add    $0xc,%esp
f0101b73:	8d 84 1b a0 0f 00 00 	lea    0xfa0(%ebx,%ebx,1),%eax
f0101b7a:	03 05 c0 76 11 f0    	add    0xf01176c0,%eax
f0101b80:	68 a0 00 00 00       	push   $0xa0
f0101b85:	56                   	push   %esi
f0101b86:	50                   	push   %eax
f0101b87:	e8 43 e6 ff ff       	call   f01001cf <memset>
        csr_y = 25 - 1;
f0101b8c:	83 c4 10             	add    $0x10,%esp
f0101b8f:	c7 05 14 42 11 f0 18 	movl   $0x18,0xf0114214
f0101b96:	00 00 00 
    }
}
f0101b99:	83 c4 04             	add    $0x4,%esp
f0101b9c:	5b                   	pop    %ebx
f0101b9d:	5e                   	pop    %esi
f0101b9e:	c3                   	ret    

f0101b9f <move_csr>:
    unsigned short temp;

    /* The equation for finding the index in a linear
    *  chunk of memory can be represented by:
    *  Index = [(y * width) + x] */
    temp = csr_y * 80 + csr_x;
f0101b9f:	66 6b 0d 14 42 11 f0 	imul   $0x50,0xf0114214,%cx
f0101ba6:	50 
f0101ba7:	ba d4 03 00 00       	mov    $0x3d4,%edx
f0101bac:	03 0d 10 42 11 f0    	add    0xf0114210,%ecx
f0101bb2:	b0 0e                	mov    $0xe,%al
f0101bb4:	ee                   	out    %al,(%dx)
    *  where the hardware cursor is to be 'blinking'. To
    *  learn more, you should look up some VGA specific
    *  programming documents. A great start to graphics:
    *  http://www.brackeen.com/home/vga */
    outb(0x3D4, 14);
    outb(0x3D5, temp >> 8);
f0101bb5:	89 c8                	mov    %ecx,%eax
f0101bb7:	b2 d5                	mov    $0xd5,%dl
f0101bb9:	66 c1 e8 08          	shr    $0x8,%ax
f0101bbd:	ee                   	out    %al,(%dx)
f0101bbe:	b0 0f                	mov    $0xf,%al
f0101bc0:	b2 d4                	mov    $0xd4,%dl
f0101bc2:	ee                   	out    %al,(%dx)
f0101bc3:	b2 d5                	mov    $0xd5,%dl
f0101bc5:	88 c8                	mov    %cl,%al
f0101bc7:	ee                   	out    %al,(%dx)
    outb(0x3D4, 15);
    outb(0x3D5, temp);
}
f0101bc8:	c3                   	ret    

f0101bc9 <sys_cls>:

/* Clears the screen */
void sys_cls()
{
f0101bc9:	56                   	push   %esi
f0101bca:	53                   	push   %ebx
    unsigned short blank;
    int i;

    /* Again, we need the 'short' that will be used to
    *  represent a space with color */
    blank = 0x0 | (attrib << 8);
f0101bcb:	31 db                	xor    %ebx,%ebx
    outb(0x3D5, temp);
}

/* Clears the screen */
void sys_cls()
{
f0101bcd:	83 ec 04             	sub    $0x4,%esp
    unsigned short blank;
    int i;

    /* Again, we need the 'short' that will be used to
    *  represent a space with color */
    blank = 0x0 | (attrib << 8);
f0101bd0:	8b 35 40 73 10 f0    	mov    0xf0107340,%esi
f0101bd6:	c1 e6 08             	shl    $0x8,%esi

    /* Sets the entire screen to spaces in our current
    *  color */
    for(i = 0; i < 25; i++)
        memset (textmemptr + i * 80, blank, 80 * 2);
f0101bd9:	0f b7 f6             	movzwl %si,%esi
f0101bdc:	a1 c0 76 11 f0       	mov    0xf01176c0,%eax
f0101be1:	51                   	push   %ecx
f0101be2:	68 a0 00 00 00       	push   $0xa0
f0101be7:	56                   	push   %esi
f0101be8:	01 d8                	add    %ebx,%eax
f0101bea:	81 c3 a0 00 00 00    	add    $0xa0,%ebx
f0101bf0:	50                   	push   %eax
f0101bf1:	e8 d9 e5 ff ff       	call   f01001cf <memset>
    *  represent a space with color */
    blank = 0x0 | (attrib << 8);

    /* Sets the entire screen to spaces in our current
    *  color */
    for(i = 0; i < 25; i++)
f0101bf6:	83 c4 10             	add    $0x10,%esp
f0101bf9:	81 fb a0 0f 00 00    	cmp    $0xfa0,%ebx
f0101bff:	75 db                	jne    f0101bdc <sys_cls+0x13>
        memset (textmemptr + i * 80, blank, 80 * 2);

    /* Update out virtual cursor, and then move the
    *  hardware cursor */
    csr_x = 0;
f0101c01:	c7 05 10 42 11 f0 00 	movl   $0x0,0xf0114210
f0101c08:	00 00 00 
    csr_y = 0;
f0101c0b:	c7 05 14 42 11 f0 00 	movl   $0x0,0xf0114214
f0101c12:	00 00 00 
    move_csr();
}
f0101c15:	83 c4 04             	add    $0x4,%esp
f0101c18:	5b                   	pop    %ebx
f0101c19:	5e                   	pop    %esi

    /* Update out virtual cursor, and then move the
    *  hardware cursor */
    csr_x = 0;
    csr_y = 0;
    move_csr();
f0101c1a:	e9 80 ff ff ff       	jmp    f0101b9f <move_csr>

f0101c1f <k_putch>:
}

/* Puts a single character on the screen */
void k_putch(unsigned char c)
{
f0101c1f:	53                   	push   %ebx
f0101c20:	83 ec 08             	sub    $0x8,%esp
    unsigned short *where;
    unsigned short att = attrib << 8;
f0101c23:	8b 0d 40 73 10 f0    	mov    0xf0107340,%ecx
    move_csr();
}

/* Puts a single character on the screen */
void k_putch(unsigned char c)
{
f0101c29:	8a 44 24 10          	mov    0x10(%esp),%al
    unsigned short *where;
    unsigned short att = attrib << 8;
f0101c2d:	c1 e1 08             	shl    $0x8,%ecx

    /* Handle a backspace, by moving the cursor back one space */
    if(c == 0x08)
f0101c30:	3c 08                	cmp    $0x8,%al
f0101c32:	75 21                	jne    f0101c55 <k_putch+0x36>
    {
        if(csr_x != 0) {
f0101c34:	a1 10 42 11 f0       	mov    0xf0114210,%eax
f0101c39:	85 c0                	test   %eax,%eax
f0101c3b:	74 7d                	je     f0101cba <k_putch+0x9b>
          where = (textmemptr-1) + (csr_y * 80 + csr_x);
f0101c3d:	6b 15 14 42 11 f0 50 	imul   $0x50,0xf0114214,%edx
f0101c44:	8d 5c 10 ff          	lea    -0x1(%eax,%edx,1),%ebx
          *where = 0x0 | att;	/* Character AND attributes: color */
f0101c48:	8b 15 c0 76 11 f0    	mov    0xf01176c0,%edx
          csr_x--;
f0101c4e:	48                   	dec    %eax
    /* Handle a backspace, by moving the cursor back one space */
    if(c == 0x08)
    {
        if(csr_x != 0) {
          where = (textmemptr-1) + (csr_y * 80 + csr_x);
          *where = 0x0 | att;	/* Character AND attributes: color */
f0101c4f:	66 89 0c 5a          	mov    %cx,(%edx,%ebx,2)
f0101c53:	eb 0f                	jmp    f0101c64 <k_putch+0x45>
          csr_x--;
        }
    }
    /* Handles a tab by incrementing the cursor's x, but only
    *  to a point that will make it divisible by 8 */
    else if(c == 0x09)
f0101c55:	3c 09                	cmp    $0x9,%al
f0101c57:	75 12                	jne    f0101c6b <k_putch+0x4c>
    {
        csr_x = (csr_x + 8) & ~(8 - 1);
f0101c59:	a1 10 42 11 f0       	mov    0xf0114210,%eax
f0101c5e:	83 c0 08             	add    $0x8,%eax
f0101c61:	83 e0 f8             	and    $0xfffffff8,%eax
f0101c64:	a3 10 42 11 f0       	mov    %eax,0xf0114210
f0101c69:	eb 4f                	jmp    f0101cba <k_putch+0x9b>
    }
    /* Handles a 'Carriage Return', which simply brings the
    *  cursor back to the margin */
    else if(c == '\r')
f0101c6b:	3c 0d                	cmp    $0xd,%al
f0101c6d:	75 0c                	jne    f0101c7b <k_putch+0x5c>
    {
        csr_x = 0;
f0101c6f:	c7 05 10 42 11 f0 00 	movl   $0x0,0xf0114210
f0101c76:	00 00 00 
f0101c79:	eb 3f                	jmp    f0101cba <k_putch+0x9b>
    }
    /* We handle our newlines the way DOS and the BIOS do: we
    *  treat it as if a 'CR' was also there, so we bring the
    *  cursor to the margin and we increment the 'y' value */
    else if(c == '\n')
f0101c7b:	3c 0a                	cmp    $0xa,%al
f0101c7d:	75 12                	jne    f0101c91 <k_putch+0x72>
    {
        csr_x = 0;
f0101c7f:	c7 05 10 42 11 f0 00 	movl   $0x0,0xf0114210
f0101c86:	00 00 00 
        csr_y++;
f0101c89:	ff 05 14 42 11 f0    	incl   0xf0114214
f0101c8f:	eb 29                	jmp    f0101cba <k_putch+0x9b>
    }
    /* Any character greater than and including a space, is a
    *  printable character. The equation for finding the index
    *  in a linear chunk of memory can be represented by:
    *  Index = [(y * width) + x] */
    else if(c >= ' ')
f0101c91:	3c 1f                	cmp    $0x1f,%al
f0101c93:	76 25                	jbe    f0101cba <k_putch+0x9b>
    {
        where = textmemptr + (csr_y * 80 + csr_x);
f0101c95:	8b 15 10 42 11 f0    	mov    0xf0114210,%edx
        *where = c | att;	/* Character AND attributes: color */
f0101c9b:	0f b6 c0             	movzbl %al,%eax
    *  printable character. The equation for finding the index
    *  in a linear chunk of memory can be represented by:
    *  Index = [(y * width) + x] */
    else if(c >= ' ')
    {
        where = textmemptr + (csr_y * 80 + csr_x);
f0101c9e:	6b 1d 14 42 11 f0 50 	imul   $0x50,0xf0114214,%ebx
        *where = c | att;	/* Character AND attributes: color */
f0101ca5:	09 c8                	or     %ecx,%eax
f0101ca7:	8b 0d c0 76 11 f0    	mov    0xf01176c0,%ecx
    *  printable character. The equation for finding the index
    *  in a linear chunk of memory can be represented by:
    *  Index = [(y * width) + x] */
    else if(c >= ' ')
    {
        where = textmemptr + (csr_y * 80 + csr_x);
f0101cad:	01 d3                	add    %edx,%ebx
        *where = c | att;	/* Character AND attributes: color */
        csr_x++;
f0101caf:	42                   	inc    %edx
    *  in a linear chunk of memory can be represented by:
    *  Index = [(y * width) + x] */
    else if(c >= ' ')
    {
        where = textmemptr + (csr_y * 80 + csr_x);
        *where = c | att;	/* Character AND attributes: color */
f0101cb0:	66 89 04 59          	mov    %ax,(%ecx,%ebx,2)
        csr_x++;
f0101cb4:	89 15 10 42 11 f0    	mov    %edx,0xf0114210
    }

    /* If the cursor has reached the edge of the screen's width, we
    *  insert a new line in there */
    if(csr_x >= 80)
f0101cba:	83 3d 10 42 11 f0 4f 	cmpl   $0x4f,0xf0114210
f0101cc1:	7e 10                	jle    f0101cd3 <k_putch+0xb4>
    {
        csr_x = 0;
        csr_y++;
f0101cc3:	ff 05 14 42 11 f0    	incl   0xf0114214

    /* If the cursor has reached the edge of the screen's width, we
    *  insert a new line in there */
    if(csr_x >= 80)
    {
        csr_x = 0;
f0101cc9:	c7 05 10 42 11 f0 00 	movl   $0x0,0xf0114210
f0101cd0:	00 00 00 
        csr_y++;
    }

    /* Scroll the screen if needed, and finally move the cursor */
    scroll();
f0101cd3:	e8 50 fe ff ff       	call   f0101b28 <scroll>
    move_csr();
}
f0101cd8:	83 c4 08             	add    $0x8,%esp
f0101cdb:	5b                   	pop    %ebx
        csr_y++;
    }

    /* Scroll the screen if needed, and finally move the cursor */
    scroll();
    move_csr();
f0101cdc:	e9 be fe ff ff       	jmp    f0101b9f <move_csr>

f0101ce1 <k_puts>:
}

/* Uses the above routine to output a string... */
void k_puts(unsigned char *text)
{
f0101ce1:	56                   	push   %esi
f0101ce2:	53                   	push   %ebx
    int i;

    for (i = 0; i < strlen((char*)text); i++)
f0101ce3:	31 db                	xor    %ebx,%ebx
    move_csr();
}

/* Uses the above routine to output a string... */
void k_puts(unsigned char *text)
{
f0101ce5:	83 ec 04             	sub    $0x4,%esp
f0101ce8:	8b 74 24 10          	mov    0x10(%esp),%esi
    int i;

    for (i = 0; i < strlen((char*)text); i++)
f0101cec:	eb 11                	jmp    f0101cff <k_puts+0x1e>
    {
        k_putch(text[i]);
f0101cee:	0f b6 04 1e          	movzbl (%esi,%ebx,1),%eax
f0101cf2:	83 ec 0c             	sub    $0xc,%esp
/* Uses the above routine to output a string... */
void k_puts(unsigned char *text)
{
    int i;

    for (i = 0; i < strlen((char*)text); i++)
f0101cf5:	43                   	inc    %ebx
    {
        k_putch(text[i]);
f0101cf6:	50                   	push   %eax
f0101cf7:	e8 23 ff ff ff       	call   f0101c1f <k_putch>
/* Uses the above routine to output a string... */
void k_puts(unsigned char *text)
{
    int i;

    for (i = 0; i < strlen((char*)text); i++)
f0101cfc:	83 c4 10             	add    $0x10,%esp
f0101cff:	83 ec 0c             	sub    $0xc,%esp
f0101d02:	56                   	push   %esi
f0101d03:	e8 f8 e2 ff ff       	call   f0100000 <strlen>
f0101d08:	83 c4 10             	add    $0x10,%esp
f0101d0b:	39 c3                	cmp    %eax,%ebx
f0101d0d:	7c df                	jl     f0101cee <k_puts+0xd>
    {
        k_putch(text[i]);
    }
}
f0101d0f:	83 c4 04             	add    $0x4,%esp
f0101d12:	5b                   	pop    %ebx
f0101d13:	5e                   	pop    %esi
f0101d14:	c3                   	ret    

f0101d15 <sys_settextcolor>:

/* Sets the forecolor and backcolor that we will use */
void sys_settextcolor(unsigned char forecolor, unsigned char backcolor)
{
    attrib = (backcolor << 4) | (forecolor & 0x0F);
f0101d15:	0f b6 44 24 08       	movzbl 0x8(%esp),%eax
f0101d1a:	0f b6 54 24 04       	movzbl 0x4(%esp),%edx
f0101d1f:	c1 e0 04             	shl    $0x4,%eax
f0101d22:	83 e2 0f             	and    $0xf,%edx
f0101d25:	09 d0                	or     %edx,%eax
f0101d27:	a3 40 73 10 f0       	mov    %eax,0xf0107340
}
f0101d2c:	c3                   	ret    

f0101d2d <init_video>:

/* Sets our text-mode VGA pointer, then clears the screen for us */
void init_video(void)
{
f0101d2d:	83 ec 0c             	sub    $0xc,%esp
    textmemptr = (unsigned short *)0xB8000;
f0101d30:	c7 05 c0 76 11 f0 00 	movl   $0xb8000,0xf01176c0
f0101d37:	80 0b 00 
    sys_cls();
}
f0101d3a:	83 c4 0c             	add    $0xc,%esp

/* Sets our text-mode VGA pointer, then clears the screen for us */
void init_video(void)
{
    textmemptr = (unsigned short *)0xB8000;
    sys_cls();
f0101d3d:	e9 87 fe ff ff       	jmp    f0101bc9 <sys_cls>
	...

f0101d44 <page_fault_handler>:
	trap_dispatch(tf);
}


void page_fault_handler(struct Trapframe *tf)
{
f0101d44:	83 ec 14             	sub    $0x14,%esp

static __inline uint32_t
rcr2(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr2,%0" : "=r" (val));
f0101d47:	0f 20 d0             	mov    %cr2,%eax
    printk("Page fault @ %p\n", rcr2());
f0101d4a:	50                   	push   %eax
f0101d4b:	68 10 57 10 f0       	push   $0xf0105710
f0101d50:	e8 7b 04 00 00       	call   f01021d0 <printk>
f0101d55:	83 c4 10             	add    $0x10,%esp
f0101d58:	eb fe                	jmp    f0101d58 <page_fault_handler+0x14>

f0101d5a <print_regs>:
		printk("  ss   0x----%04x\n", tf->tf_ss);
	}
}
void
print_regs(struct PushRegs *regs)
{
f0101d5a:	53                   	push   %ebx
f0101d5b:	83 ec 10             	sub    $0x10,%esp
f0101d5e:	8b 5c 24 18          	mov    0x18(%esp),%ebx
	printk("  edi  0x%08x\n", regs->reg_edi);
f0101d62:	ff 33                	pushl  (%ebx)
f0101d64:	68 21 57 10 f0       	push   $0xf0105721
f0101d69:	e8 62 04 00 00       	call   f01021d0 <printk>
	printk("  esi  0x%08x\n", regs->reg_esi);
f0101d6e:	58                   	pop    %eax
f0101d6f:	5a                   	pop    %edx
f0101d70:	ff 73 04             	pushl  0x4(%ebx)
f0101d73:	68 30 57 10 f0       	push   $0xf0105730
f0101d78:	e8 53 04 00 00       	call   f01021d0 <printk>
	printk("  ebp  0x%08x\n", regs->reg_ebp);
f0101d7d:	5a                   	pop    %edx
f0101d7e:	59                   	pop    %ecx
f0101d7f:	ff 73 08             	pushl  0x8(%ebx)
f0101d82:	68 3f 57 10 f0       	push   $0xf010573f
f0101d87:	e8 44 04 00 00       	call   f01021d0 <printk>
	printk("  oesp 0x%08x\n", regs->reg_oesp);
f0101d8c:	59                   	pop    %ecx
f0101d8d:	58                   	pop    %eax
f0101d8e:	ff 73 0c             	pushl  0xc(%ebx)
f0101d91:	68 4e 57 10 f0       	push   $0xf010574e
f0101d96:	e8 35 04 00 00       	call   f01021d0 <printk>
	printk("  ebx  0x%08x\n", regs->reg_ebx);
f0101d9b:	58                   	pop    %eax
f0101d9c:	5a                   	pop    %edx
f0101d9d:	ff 73 10             	pushl  0x10(%ebx)
f0101da0:	68 5d 57 10 f0       	push   $0xf010575d
f0101da5:	e8 26 04 00 00       	call   f01021d0 <printk>
	printk("  edx  0x%08x\n", regs->reg_edx);
f0101daa:	5a                   	pop    %edx
f0101dab:	59                   	pop    %ecx
f0101dac:	ff 73 14             	pushl  0x14(%ebx)
f0101daf:	68 6c 57 10 f0       	push   $0xf010576c
f0101db4:	e8 17 04 00 00       	call   f01021d0 <printk>
	printk("  ecx  0x%08x\n", regs->reg_ecx);
f0101db9:	59                   	pop    %ecx
f0101dba:	58                   	pop    %eax
f0101dbb:	ff 73 18             	pushl  0x18(%ebx)
f0101dbe:	68 7b 57 10 f0       	push   $0xf010577b
f0101dc3:	e8 08 04 00 00       	call   f01021d0 <printk>
	printk("  eax  0x%08x\n", regs->reg_eax);
f0101dc8:	58                   	pop    %eax
f0101dc9:	5a                   	pop    %edx
f0101dca:	ff 73 1c             	pushl  0x1c(%ebx)
f0101dcd:	68 8a 57 10 f0       	push   $0xf010578a
f0101dd2:	e8 f9 03 00 00       	call   f01021d0 <printk>
}
f0101dd7:	83 c4 18             	add    $0x18,%esp
f0101dda:	5b                   	pop    %ebx
f0101ddb:	c3                   	ret    

f0101ddc <print_trapframe>:
	return "(unknown trap)";
}

void
print_trapframe(struct Trapframe *tf)
{
f0101ddc:	56                   	push   %esi
f0101ddd:	53                   	push   %ebx
f0101dde:	83 ec 0c             	sub    $0xc,%esp
f0101de1:	8b 5c 24 18          	mov    0x18(%esp),%ebx
	printk("TRAP frame at %p \n", tf);
f0101de5:	53                   	push   %ebx
f0101de6:	68 f5 57 10 f0       	push   $0xf01057f5
f0101deb:	e8 e0 03 00 00       	call   f01021d0 <printk>
	print_regs(&tf->tf_regs);
f0101df0:	89 1c 24             	mov    %ebx,(%esp)
f0101df3:	e8 62 ff ff ff       	call   f0101d5a <print_regs>
	printk("  es   0x----%04x\n", tf->tf_es);
f0101df8:	0f b7 43 20          	movzwl 0x20(%ebx),%eax
f0101dfc:	5a                   	pop    %edx
f0101dfd:	59                   	pop    %ecx
f0101dfe:	50                   	push   %eax
f0101dff:	68 08 58 10 f0       	push   $0xf0105808
f0101e04:	e8 c7 03 00 00       	call   f01021d0 <printk>
	printk("  ds   0x----%04x\n", tf->tf_ds);
f0101e09:	5e                   	pop    %esi
f0101e0a:	58                   	pop    %eax
f0101e0b:	0f b7 43 24          	movzwl 0x24(%ebx),%eax
f0101e0f:	50                   	push   %eax
f0101e10:	68 1b 58 10 f0       	push   $0xf010581b
f0101e15:	e8 b6 03 00 00       	call   f01021d0 <printk>
	printk("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0101e1a:	8b 43 28             	mov    0x28(%ebx),%eax
		"Alignment Check",
		"Machine-Check",
		"SIMD Floating-Point Exception"
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
f0101e1d:	83 c4 10             	add    $0x10,%esp
f0101e20:	83 f8 13             	cmp    $0x13,%eax
f0101e23:	77 09                	ja     f0101e2e <print_trapframe+0x52>
		return excnames[trapno];
f0101e25:	8b 14 85 4c 5a 10 f0 	mov    -0xfefa5b4(,%eax,4),%edx
f0101e2c:	eb 1d                	jmp    f0101e4b <print_trapframe+0x6f>
	if (trapno == T_SYSCALL)
f0101e2e:	83 f8 30             	cmp    $0x30,%eax
		return "System call";
f0101e31:	ba 99 57 10 f0       	mov    $0xf0105799,%edx
		"SIMD Floating-Point Exception"
	};

	if (trapno < sizeof(excnames)/sizeof(excnames[0]))
		return excnames[trapno];
	if (trapno == T_SYSCALL)
f0101e36:	74 13                	je     f0101e4b <print_trapframe+0x6f>
		return "System call";
	if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16)
f0101e38:	8d 48 e0             	lea    -0x20(%eax),%ecx
		return "Hardware Interrupt";
f0101e3b:	ba a5 57 10 f0       	mov    $0xf01057a5,%edx
f0101e40:	83 f9 0f             	cmp    $0xf,%ecx
f0101e43:	b9 b8 57 10 f0       	mov    $0xf01057b8,%ecx
f0101e48:	0f 47 d1             	cmova  %ecx,%edx
{
	printk("TRAP frame at %p \n", tf);
	print_regs(&tf->tf_regs);
	printk("  es   0x----%04x\n", tf->tf_es);
	printk("  ds   0x----%04x\n", tf->tf_ds);
	printk("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
f0101e4b:	51                   	push   %ecx
f0101e4c:	52                   	push   %edx
f0101e4d:	50                   	push   %eax
f0101e4e:	68 2e 58 10 f0       	push   $0xf010582e
f0101e53:	e8 78 03 00 00       	call   f01021d0 <printk>
	// If this trap was a page fault that just happened
	// (so %cr2 is meaningful), print the faulting linear address.
	if (tf == last_tf && tf->tf_trapno == T_PGFLT)
f0101e58:	83 c4 10             	add    $0x10,%esp
f0101e5b:	3b 1d 18 4e 11 f0    	cmp    0xf0114e18,%ebx
f0101e61:	75 19                	jne    f0101e7c <print_trapframe+0xa0>
f0101e63:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0101e67:	75 13                	jne    f0101e7c <print_trapframe+0xa0>
f0101e69:	0f 20 d0             	mov    %cr2,%eax
		printk("  cr2  0x%08x\n", rcr2());
f0101e6c:	52                   	push   %edx
f0101e6d:	52                   	push   %edx
f0101e6e:	50                   	push   %eax
f0101e6f:	68 40 58 10 f0       	push   $0xf0105840
f0101e74:	e8 57 03 00 00       	call   f01021d0 <printk>
f0101e79:	83 c4 10             	add    $0x10,%esp
	printk("  err  0x%08x", tf->tf_err);
f0101e7c:	56                   	push   %esi
f0101e7d:	56                   	push   %esi
f0101e7e:	ff 73 2c             	pushl  0x2c(%ebx)
f0101e81:	68 4f 58 10 f0       	push   $0xf010584f
f0101e86:	e8 45 03 00 00       	call   f01021d0 <printk>
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
f0101e8b:	83 c4 10             	add    $0x10,%esp
f0101e8e:	83 7b 28 0e          	cmpl   $0xe,0x28(%ebx)
f0101e92:	75 43                	jne    f0101ed7 <print_trapframe+0xfb>
		printk(" [%s, %s, %s]\n",
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
f0101e94:	8b 73 2c             	mov    0x2c(%ebx),%esi
	// For page faults, print decoded fault error code:
	// U/K=fault occurred in user/kernel mode
	// W/R=a write/read caused the fault
	// PR=a protection violation caused the fault (NP=page not present).
	if (tf->tf_trapno == T_PGFLT)
		printk(" [%s, %s, %s]\n",
f0101e97:	b8 d2 57 10 f0       	mov    $0xf01057d2,%eax
f0101e9c:	b9 c7 57 10 f0       	mov    $0xf01057c7,%ecx
f0101ea1:	ba de 57 10 f0       	mov    $0xf01057de,%edx
f0101ea6:	f7 c6 01 00 00 00    	test   $0x1,%esi
f0101eac:	0f 44 c8             	cmove  %eax,%ecx
f0101eaf:	f7 c6 02 00 00 00    	test   $0x2,%esi
f0101eb5:	b8 e4 57 10 f0       	mov    $0xf01057e4,%eax
f0101eba:	0f 44 d0             	cmove  %eax,%edx
f0101ebd:	83 e6 04             	and    $0x4,%esi
f0101ec0:	51                   	push   %ecx
f0101ec1:	b8 e9 57 10 f0       	mov    $0xf01057e9,%eax
f0101ec6:	be ee 57 10 f0       	mov    $0xf01057ee,%esi
f0101ecb:	52                   	push   %edx
f0101ecc:	0f 44 c6             	cmove  %esi,%eax
f0101ecf:	50                   	push   %eax
f0101ed0:	68 5d 58 10 f0       	push   $0xf010585d
f0101ed5:	eb 08                	jmp    f0101edf <print_trapframe+0x103>
			tf->tf_err & 4 ? "user" : "kernel",
			tf->tf_err & 2 ? "write" : "read",
			tf->tf_err & 1 ? "protection" : "not-present");
	else
		printk("\n");
f0101ed7:	83 ec 0c             	sub    $0xc,%esp
f0101eda:	68 06 58 10 f0       	push   $0xf0105806
f0101edf:	e8 ec 02 00 00       	call   f01021d0 <printk>
f0101ee4:	5a                   	pop    %edx
f0101ee5:	59                   	pop    %ecx
	printk("  eip  0x%08x\n", tf->tf_eip);
f0101ee6:	ff 73 30             	pushl  0x30(%ebx)
f0101ee9:	68 6c 58 10 f0       	push   $0xf010586c
f0101eee:	e8 dd 02 00 00       	call   f01021d0 <printk>
	printk("  cs   0x----%04x\n", tf->tf_cs);
f0101ef3:	5e                   	pop    %esi
f0101ef4:	58                   	pop    %eax
f0101ef5:	0f b7 43 34          	movzwl 0x34(%ebx),%eax
f0101ef9:	50                   	push   %eax
f0101efa:	68 7b 58 10 f0       	push   $0xf010587b
f0101eff:	e8 cc 02 00 00       	call   f01021d0 <printk>
	printk("  flag 0x%08x\n", tf->tf_eflags);
f0101f04:	5a                   	pop    %edx
f0101f05:	59                   	pop    %ecx
f0101f06:	ff 73 38             	pushl  0x38(%ebx)
f0101f09:	68 8e 58 10 f0       	push   $0xf010588e
f0101f0e:	e8 bd 02 00 00       	call   f01021d0 <printk>
	if ((tf->tf_cs & 3) != 0) {
f0101f13:	83 c4 10             	add    $0x10,%esp
f0101f16:	f6 43 34 03          	testb  $0x3,0x34(%ebx)
f0101f1a:	74 23                	je     f0101f3f <print_trapframe+0x163>
		printk("  esp  0x%08x\n", tf->tf_esp);
f0101f1c:	50                   	push   %eax
f0101f1d:	50                   	push   %eax
f0101f1e:	ff 73 3c             	pushl  0x3c(%ebx)
f0101f21:	68 9d 58 10 f0       	push   $0xf010589d
f0101f26:	e8 a5 02 00 00       	call   f01021d0 <printk>
		printk("  ss   0x----%04x\n", tf->tf_ss);
f0101f2b:	0f b7 43 40          	movzwl 0x40(%ebx),%eax
f0101f2f:	59                   	pop    %ecx
f0101f30:	5e                   	pop    %esi
f0101f31:	50                   	push   %eax
f0101f32:	68 ac 58 10 f0       	push   $0xf01058ac
f0101f37:	e8 94 02 00 00       	call   f01021d0 <printk>
f0101f3c:	83 c4 10             	add    $0x10,%esp
	}
}
f0101f3f:	83 c4 04             	add    $0x4,%esp
f0101f42:	5b                   	pop    %ebx
f0101f43:	5e                   	pop    %esi
f0101f44:	c3                   	ret    

f0101f45 <register_handler>:
	printk("  ecx  0x%08x\n", regs->reg_ecx);
	printk("  eax  0x%08x\n", regs->reg_eax);
}

void register_handler(int trapno, TrapHandler hnd, void (*trap_entry)(void), int isTrap, int dpl)
{
f0101f45:	53                   	push   %ebx
f0101f46:	8b 4c 24 10          	mov    0x10(%esp),%ecx
f0101f4a:	8b 44 24 08          	mov    0x8(%esp),%eax
	if (trapno >= 0 && trapno < 256 && trap_entry != NULL)
f0101f4e:	85 c9                	test   %ecx,%ecx
f0101f50:	74 5a                	je     f0101fac <register_handler+0x67>
f0101f52:	3d ff 00 00 00       	cmp    $0xff,%eax
f0101f57:	77 53                	ja     f0101fac <register_handler+0x67>
	{
		trap_hnd[trapno] = hnd;
f0101f59:	8b 54 24 0c          	mov    0xc(%esp),%edx
		/* Set trap gate */
		SETGATE(idt[trapno], isTrap, GD_KT, trap_entry, dpl);
f0101f5d:	83 7c 24 14 01       	cmpl   $0x1,0x14(%esp)
f0101f62:	8b 5c 24 18          	mov    0x18(%esp),%ebx
f0101f66:	66 89 0c c5 18 42 11 	mov    %cx,-0xfeebde8(,%eax,8)
f0101f6d:	f0 

void register_handler(int trapno, TrapHandler hnd, void (*trap_entry)(void), int isTrap, int dpl)
{
	if (trapno >= 0 && trapno < 256 && trap_entry != NULL)
	{
		trap_hnd[trapno] = hnd;
f0101f6e:	89 14 85 18 4a 11 f0 	mov    %edx,-0xfeeb5e8(,%eax,4)
		/* Set trap gate */
		SETGATE(idt[trapno], isTrap, GD_KT, trap_entry, dpl);
f0101f75:	19 d2                	sbb    %edx,%edx
f0101f77:	83 c2 0f             	add    $0xf,%edx
f0101f7a:	83 e3 03             	and    $0x3,%ebx
f0101f7d:	83 e2 0f             	and    $0xf,%edx
f0101f80:	c1 e3 05             	shl    $0x5,%ebx
f0101f83:	09 da                	or     %ebx,%edx
f0101f85:	83 ca 80             	or     $0xffffff80,%edx
f0101f88:	c1 e9 10             	shr    $0x10,%ecx
f0101f8b:	66 c7 04 c5 1a 42 11 	movw   $0x8,-0xfeebde6(,%eax,8)
f0101f92:	f0 08 00 
f0101f95:	c6 04 c5 1c 42 11 f0 	movb   $0x0,-0xfeebde4(,%eax,8)
f0101f9c:	00 
f0101f9d:	88 14 c5 1d 42 11 f0 	mov    %dl,-0xfeebde3(,%eax,8)
f0101fa4:	66 89 0c c5 1e 42 11 	mov    %cx,-0xfeebde2(,%eax,8)
f0101fab:	f0 
	}
}
f0101fac:	5b                   	pop    %ebx
f0101fad:	c3                   	ret    

f0101fae <env_pop_tf>:
//
// This function does not return.
//
void
env_pop_tf(struct Trapframe *tf)
{
f0101fae:	83 ec 10             	sub    $0x10,%esp
	__asm __volatile("movl %0,%%esp\n"
f0101fb1:	8b 64 24 14          	mov    0x14(%esp),%esp
f0101fb5:	61                   	popa   
f0101fb6:	07                   	pop    %es
f0101fb7:	1f                   	pop    %ds
f0101fb8:	83 c4 08             	add    $0x8,%esp
f0101fbb:	cf                   	iret   
		"\tpopl %%es\n"
		"\tpopl %%ds\n"
		"\taddl $0x8,%%esp\n" /* skip tf_trapno and tf_errcode */
		"\tiret"
		: : "g" (tf) : "memory");
	panic("iret failed");  /* mostly to placate the compiler */
f0101fbc:	68 bf 58 10 f0       	push   $0xf01058bf
f0101fc1:	68 83 00 00 00       	push   $0x83
f0101fc6:	68 cb 58 10 f0       	push   $0xf01058cb
f0101fcb:	e8 18 1c 00 00       	call   f0103be8 <_panic>

f0101fd0 <default_trap_handler>:
	panic("Unexpected trap!");
	
}

void default_trap_handler(struct Trapframe *tf)
{
f0101fd0:	57                   	push   %edi
f0101fd1:	56                   	push   %esi
f0101fd2:	83 ec 04             	sub    $0x4,%esp
f0101fd5:	8b 74 24 10          	mov    0x10(%esp),%esi
trap_dispatch(struct Trapframe *tf)
{
	// Handle spurious interrupts
	// The hardware sometimes raises these because of noise on the
	// IRQ line or other reasons. We don't care.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
f0101fd9:	8b 46 28             	mov    0x28(%esi),%eax

void default_trap_handler(struct Trapframe *tf)
{
	// Record that tf is the last real trapframe so
	// print_trapframe can print some additional information.
	last_tf = tf;
f0101fdc:	89 35 18 4e 11 f0    	mov    %esi,0xf0114e18
trap_dispatch(struct Trapframe *tf)
{
	// Handle spurious interrupts
	// The hardware sometimes raises these because of noise on the
	// IRQ line or other reasons. We don't care.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
f0101fe2:	83 f8 27             	cmp    $0x27,%eax
f0101fe5:	75 1b                	jne    f0102002 <default_trap_handler+0x32>
		printk("Spurious interrupt on irq 7\n");
f0101fe7:	83 ec 0c             	sub    $0xc,%esp
f0101fea:	68 d9 58 10 f0       	push   $0xf01058d9
f0101fef:	e8 dc 01 00 00       	call   f01021d0 <printk>
		print_trapframe(tf);
f0101ff4:	89 74 24 20          	mov    %esi,0x20(%esp)
	// print_trapframe can print some additional information.
	last_tf = tf;

	// Dispatch based on what type of trap occurred
	trap_dispatch(tf);
}
f0101ff8:	83 c4 14             	add    $0x14,%esp
f0101ffb:	5e                   	pop    %esi
f0101ffc:	5f                   	pop    %edi
	// Handle spurious interrupts
	// The hardware sometimes raises these because of noise on the
	// IRQ line or other reasons. We don't care.
	if (tf->tf_trapno == IRQ_OFFSET + IRQ_SPURIOUS) {
		printk("Spurious interrupt on irq 7\n");
		print_trapframe(tf);
f0101ffd:	e9 da fd ff ff       	jmp    f0101ddc <print_trapframe>
		return;
	}

	last_tf = tf;
	/* Lab3: Check the trap number and call the interrupt handler. */
	if (trap_hnd[tf->tf_trapno] != NULL)
f0102002:	83 3c 85 18 4a 11 f0 	cmpl   $0x0,-0xfeeb5e8(,%eax,4)
f0102009:	00 
f010200a:	74 3b                	je     f0102047 <default_trap_handler+0x77>
	{
	
		if ((tf->tf_cs & 3) == 3)
f010200c:	0f b7 46 34          	movzwl 0x34(%esi),%eax
f0102010:	83 e0 03             	and    $0x3,%eax
f0102013:	83 f8 03             	cmp    $0x3,%eax
f0102016:	75 13                	jne    f010202b <default_trap_handler+0x5b>
			// Trapped from user mode.
			extern Task *cur_task;

			// Disable interrupt first
			// Think: Why we disable interrupt here?
			__asm __volatile("cli");
f0102018:	fa                   	cli    

			// Copy trap frame (which is currently on the stack)
			// into 'cur_task->tf', so that running the environment
			// will restart at the trap point.
			cur_task->tf = *tf;
f0102019:	a1 2c 4e 11 f0       	mov    0xf0114e2c,%eax
f010201e:	b9 11 00 00 00       	mov    $0x11,%ecx
f0102023:	8d 78 08             	lea    0x8(%eax),%edi
f0102026:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
			tf = &(cur_task->tf);
f0102028:	8d 70 08             	lea    0x8(%eax),%esi
				
		}
		// Do ISR
		trap_hnd[tf->tf_trapno](tf);
f010202b:	8b 46 28             	mov    0x28(%esi),%eax
f010202e:	83 ec 0c             	sub    $0xc,%esp
f0102031:	56                   	push   %esi
f0102032:	ff 14 85 18 4a 11 f0 	call   *-0xfeeb5e8(,%eax,4)
		
		// Pop the kernel stack 
		env_pop_tf(tf);
f0102039:	89 74 24 20          	mov    %esi,0x20(%esp)
	// print_trapframe can print some additional information.
	last_tf = tf;

	// Dispatch based on what type of trap occurred
	trap_dispatch(tf);
}
f010203d:	83 c4 14             	add    $0x14,%esp
f0102040:	5e                   	pop    %esi
f0102041:	5f                   	pop    %edi
		}
		// Do ISR
		trap_hnd[tf->tf_trapno](tf);
		
		// Pop the kernel stack 
		env_pop_tf(tf);
f0102042:	e9 67 ff ff ff       	jmp    f0101fae <env_pop_tf>
		return;
	}

	// Unexpected trap: The user process or the kernel has a bug.
	print_trapframe(tf);
f0102047:	83 ec 0c             	sub    $0xc,%esp
f010204a:	56                   	push   %esi
f010204b:	e8 8c fd ff ff       	call   f0101ddc <print_trapframe>
	panic("Unexpected trap!");
f0102050:	83 c4 0c             	add    $0xc,%esp
f0102053:	68 f6 58 10 f0       	push   $0xf01058f6
f0102058:	68 b1 00 00 00       	push   $0xb1
f010205d:	68 cb 58 10 f0       	push   $0xf01058cb
f0102062:	e8 81 1b 00 00       	call   f0103be8 <_panic>

f0102067 <trap_init>:
	int i;
	/* Initial interrupt descrip table for all traps */
	extern void Default_ISR();
	for (i = 0; i < 256; i++)
	{
		SETGATE(idt[i], 1, GD_KT, Default_ISR, 0);
f0102067:	b9 2c 21 10 f0       	mov    $0xf010212c,%ecx
void trap_init()
{
	int i;
	/* Initial interrupt descrip table for all traps */
	extern void Default_ISR();
	for (i = 0; i < 256; i++)
f010206c:	31 c0                	xor    %eax,%eax
	{
		SETGATE(idt[i], 1, GD_KT, Default_ISR, 0);
f010206e:	c1 e9 10             	shr    $0x10,%ecx
f0102071:	ba 2c 21 10 f0       	mov    $0xf010212c,%edx
f0102076:	66 89 14 c5 18 42 11 	mov    %dx,-0xfeebde8(,%eax,8)
f010207d:	f0 
f010207e:	66 c7 04 c5 1a 42 11 	movw   $0x8,-0xfeebde6(,%eax,8)
f0102085:	f0 08 00 
f0102088:	c6 04 c5 1c 42 11 f0 	movb   $0x0,-0xfeebde4(,%eax,8)
f010208f:	00 
f0102090:	c6 04 c5 1d 42 11 f0 	movb   $0x8f,-0xfeebde3(,%eax,8)
f0102097:	8f 
f0102098:	66 89 0c c5 1e 42 11 	mov    %cx,-0xfeebde2(,%eax,8)
f010209f:	f0 
		trap_hnd[i] = NULL;
f01020a0:	c7 04 85 18 4a 11 f0 	movl   $0x0,-0xfeeb5e8(,%eax,4)
f01020a7:	00 00 00 00 
void trap_init()
{
	int i;
	/* Initial interrupt descrip table for all traps */
	extern void Default_ISR();
	for (i = 0; i < 256; i++)
f01020ab:	40                   	inc    %eax
f01020ac:	3d 00 01 00 00       	cmp    $0x100,%eax
f01020b1:	75 c3                	jne    f0102076 <trap_init+0xf>
	extern void STACK_ISR();
	SETGATE(idt[T_STACK], 1, GD_KT, STACK_ISR, 0);

  /* Using custom trap handler */
	extern void PGFLT();
    register_handler(T_PGFLT, page_fault_handler, PGFLT, 1, 0);
f01020b3:	6a 00                	push   $0x0
	}


  /* Using default_trap_handler */
	extern void GPFLT();
	SETGATE(idt[T_GPFLT], 1, GD_KT, GPFLT, 0);
f01020b5:	b8 48 21 10 f0       	mov    $0xf0102148,%eax
	extern void STACK_ISR();
	SETGATE(idt[T_STACK], 1, GD_KT, STACK_ISR, 0);

  /* Using custom trap handler */
	extern void PGFLT();
    register_handler(T_PGFLT, page_fault_handler, PGFLT, 1, 0);
f01020ba:	6a 01                	push   $0x1
f01020bc:	68 54 21 10 f0       	push   $0xf0102154
f01020c1:	68 44 1d 10 f0       	push   $0xf0101d44
f01020c6:	6a 0e                	push   $0xe
	}


  /* Using default_trap_handler */
	extern void GPFLT();
	SETGATE(idt[T_GPFLT], 1, GD_KT, GPFLT, 0);
f01020c8:	66 a3 80 42 11 f0    	mov    %ax,0xf0114280
f01020ce:	c1 e8 10             	shr    $0x10,%eax
f01020d1:	66 a3 86 42 11 f0    	mov    %ax,0xf0114286
	extern void STACK_ISR();
	SETGATE(idt[T_STACK], 1, GD_KT, STACK_ISR, 0);
f01020d7:	b8 4e 21 10 f0       	mov    $0xf010214e,%eax
f01020dc:	66 a3 78 42 11 f0    	mov    %ax,0xf0114278
f01020e2:	c1 e8 10             	shr    $0x10,%eax
f01020e5:	66 a3 7e 42 11 f0    	mov    %ax,0xf011427e
	}


  /* Using default_trap_handler */
	extern void GPFLT();
	SETGATE(idt[T_GPFLT], 1, GD_KT, GPFLT, 0);
f01020eb:	66 c7 05 82 42 11 f0 	movw   $0x8,0xf0114282
f01020f2:	08 00 
f01020f4:	c6 05 84 42 11 f0 00 	movb   $0x0,0xf0114284
f01020fb:	c6 05 85 42 11 f0 8f 	movb   $0x8f,0xf0114285
	extern void STACK_ISR();
	SETGATE(idt[T_STACK], 1, GD_KT, STACK_ISR, 0);
f0102102:	66 c7 05 7a 42 11 f0 	movw   $0x8,0xf011427a
f0102109:	08 00 
f010210b:	c6 05 7c 42 11 f0 00 	movb   $0x0,0xf011427c
f0102112:	c6 05 7d 42 11 f0 8f 	movb   $0x8f,0xf011427d

  /* Using custom trap handler */
	extern void PGFLT();
    register_handler(T_PGFLT, page_fault_handler, PGFLT, 1, 0);
f0102119:	e8 27 fe ff ff       	call   f0101f45 <register_handler>
}

static __inline void
lidt(void *p)
{
	__asm __volatile("lidt (%0)" : : "r" (p));
f010211e:	b8 44 73 10 f0       	mov    $0xf0107344,%eax
f0102123:	0f 01 18             	lidtl  (%eax)
f0102126:	83 c4 14             	add    $0x14,%esp

	lidt(&idt_pd);
}
f0102129:	c3                   	ret    
	...

f010212c <Default_ISR>:
	jmp _alltraps

.text

/* ISRs */
TRAPHANDLER_NOEC(Default_ISR, T_DEFAULT)
f010212c:	6a 00                	push   $0x0
f010212e:	68 f4 01 00 00       	push   $0x1f4
f0102133:	eb 25                	jmp    f010215a <_alltraps>
f0102135:	90                   	nop

f0102136 <KBD_Input>:
TRAPHANDLER_NOEC(KBD_Input, IRQ_OFFSET+IRQ_KBD)
f0102136:	6a 00                	push   $0x0
f0102138:	6a 21                	push   $0x21
f010213a:	eb 1e                	jmp    f010215a <_alltraps>

f010213c <TIM_ISR>:
TRAPHANDLER_NOEC(TIM_ISR, IRQ_OFFSET+IRQ_TIMER)
f010213c:	6a 00                	push   $0x0
f010213e:	6a 20                	push   $0x20
f0102140:	eb 18                	jmp    f010215a <_alltraps>

f0102142 <do_sys>:
TRAPHANDLER_NOEC(do_sys, T_SYSCALL)
f0102142:	6a 00                	push   $0x0
f0102144:	6a 30                	push   $0x30
f0102146:	eb 12                	jmp    f010215a <_alltraps>

f0102148 <GPFLT>:
// TODO: Lab 5
// Please add interface of system call

TRAPHANDLER_NOEC(GPFLT, T_GPFLT)
f0102148:	6a 00                	push   $0x0
f010214a:	6a 0d                	push   $0xd
f010214c:	eb 0c                	jmp    f010215a <_alltraps>

f010214e <STACK_ISR>:
TRAPHANDLER_NOEC(STACK_ISR, T_STACK)
f010214e:	6a 00                	push   $0x0
f0102150:	6a 0c                	push   $0xc
f0102152:	eb 06                	jmp    f010215a <_alltraps>

f0102154 <PGFLT>:
TRAPHANDLER_NOEC(PGFLT, T_PGFLT)
f0102154:	6a 00                	push   $0x0
f0102156:	6a 0e                	push   $0xe
f0102158:	eb 00                	jmp    f010215a <_alltraps>

f010215a <_alltraps>:
_alltraps:
	/* Lab3: Push the registers into stack( fill the Trapframe structure )
	 * You can reference the http://www.osdever.net/bkerndev/Docs/isrs.htm
	 * After stack parpared, just "call default_trap_handler".
	 */
	pushl %ds
f010215a:	1e                   	push   %ds
	pushl %es
f010215b:	06                   	push   %es
	pushal # Push all general register into stack, it maps to Trapframe.tf_regs
f010215c:	60                   	pusha  
	/* Load the Kernel Data Segment descriptor */
	mov $(GD_KD), %ax
f010215d:	66 b8 10 00          	mov    $0x10,%ax
	mov %ax, %ds
f0102161:	8e d8                	mov    %eax,%ds
	mov %ax, %es
f0102163:	8e c0                	mov    %eax,%es
	mov %ax, %fs
f0102165:	8e e0                	mov    %eax,%fs
	mov %ax, %gs
f0102167:	8e e8                	mov    %eax,%gs
	
	pushl %esp # Pass a pointer to the Trapframe as an argument to default_trap_handler()
f0102169:	54                   	push   %esp
	call default_trap_handler
f010216a:	e8 61 fe ff ff       	call   f0101fd0 <default_trap_handler>
	
	/* Restore fs and gs to user data segmemnt */
	push %ax
f010216f:	66 50                	push   %ax
	mov $(GD_UD), %ax
f0102171:	66 b8 20 00          	mov    $0x20,%ax
	or $3, %ax
f0102175:	66 83 c8 03          	or     $0x3,%ax
	mov %ax, %fs
f0102179:	8e e0                	mov    %eax,%fs
	mov %ax, %gs
f010217b:	8e e8                	mov    %eax,%gs
	pop %ax 
f010217d:	66 58                	pop    %ax
	add $4, %esp
f010217f:	83 c4 04             	add    $0x4,%esp

f0102182 <trapret>:

# Return falls through to trapret...
.globl trapret
trapret:
  popal
f0102182:	61                   	popa   
  popl %es
f0102183:	07                   	pop    %es
  popl %ds
f0102184:	1f                   	pop    %ds
  addl $0x8, %esp  # trapno and errcode
f0102185:	83 c4 08             	add    $0x8,%esp
  iret
f0102188:	cf                   	iret   
f0102189:	00 00                	add    %al,(%eax)
	...

f010218c <putch>:
#include <inc/types.h>
#include <inc/stdio.h>

static void
putch(int ch, int *cnt)
{
f010218c:	53                   	push   %ebx
f010218d:	83 ec 14             	sub    $0x14,%esp
	k_putch(ch); // in kernel/screen.c
f0102190:	0f b6 44 24 1c       	movzbl 0x1c(%esp),%eax
#include <inc/types.h>
#include <inc/stdio.h>

static void
putch(int ch, int *cnt)
{
f0102195:	8b 5c 24 20          	mov    0x20(%esp),%ebx
	k_putch(ch); // in kernel/screen.c
f0102199:	50                   	push   %eax
f010219a:	e8 80 fa ff ff       	call   f0101c1f <k_putch>
	(*cnt)++;
f010219f:	ff 03                	incl   (%ebx)
}
f01021a1:	83 c4 18             	add    $0x18,%esp
f01021a4:	5b                   	pop    %ebx
f01021a5:	c3                   	ret    

f01021a6 <vprintk>:

int
vprintk(const char *fmt, va_list ap)
{
f01021a6:	83 ec 1c             	sub    $0x1c,%esp
	int cnt = 0;
f01021a9:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
f01021b0:	00 

	vprintfmt((void*)putch, &cnt, fmt, ap);
f01021b1:	ff 74 24 24          	pushl  0x24(%esp)
f01021b5:	ff 74 24 24          	pushl  0x24(%esp)
f01021b9:	8d 44 24 14          	lea    0x14(%esp),%eax
f01021bd:	50                   	push   %eax
f01021be:	68 8c 21 10 f0       	push   $0xf010218c
f01021c3:	e8 a7 e4 ff ff       	call   f010066f <vprintfmt>
	return cnt;
}
f01021c8:	8b 44 24 1c          	mov    0x1c(%esp),%eax
f01021cc:	83 c4 2c             	add    $0x2c,%esp
f01021cf:	c3                   	ret    

f01021d0 <printk>:

int
printk(const char *fmt, ...)
{
f01021d0:	83 ec 0c             	sub    $0xc,%esp
	va_list ap;
	int cnt;

	va_start(ap, fmt);
f01021d3:	8d 44 24 14          	lea    0x14(%esp),%eax
	cnt = vprintk(fmt, ap);
f01021d7:	52                   	push   %edx
f01021d8:	52                   	push   %edx
f01021d9:	50                   	push   %eax
f01021da:	ff 74 24 1c          	pushl  0x1c(%esp)
f01021de:	e8 c3 ff ff ff       	call   f01021a6 <vprintk>
	va_end(ap);

	return cnt;
}
f01021e3:	83 c4 1c             	add    $0x1c,%esp
f01021e6:	c3                   	ret    
	...

f01021e8 <page2pa>:
}

static inline physaddr_t
page2pa(struct PageInfo *pp)
{
	return (pp - pages) << PGSHIFT;
f01021e8:	2b 05 d0 76 11 f0    	sub    0xf01176d0,%eax
f01021ee:	c1 f8 03             	sar    $0x3,%eax
f01021f1:	c1 e0 0c             	shl    $0xc,%eax
}
f01021f4:	c3                   	ret    

f01021f5 <boot_alloc>:
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,#end is behind on bss
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree) {
f01021f5:	83 3d 24 4e 11 f0 00 	cmpl   $0x0,0xf0114e24
// This function may ONLY be used during initialization,
// before the page_free_list list has been set up.
// boot_alloc return the address which can be used
static void *
boot_alloc(uint32_t n)
{
f01021fc:	89 c2                	mov    %eax,%edx
	// Initialize nextfree if this is the first time.
	// 'end' is a magic symbol automatically generated by the linker,#end is behind on bss
	// which points to the end of the kernel's bss segment:
	// the first virtual address that the linker did *not* assign
	// to any kernel code or global variables.
	if (!nextfree) {
f01021fe:	75 11                	jne    f0102211 <boot_alloc+0x1c>
		extern char end[];
		nextfree = ROUNDUP((char *) end, PGSIZE);
f0102200:	b9 57 8a 11 f0       	mov    $0xf0118a57,%ecx
f0102205:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f010220b:	89 0d 24 4e 11 f0    	mov    %ecx,0xf0114e24

	//!! Allocate a chunk large enough to hold 'n' bytes, then update
	//!! nextfree.  Make sure nextfree is kept aligned
	//!!! to a multiple of PGSIZE.
    //if n is zero return the address currently, else return the address can be div by page
    if (n == 0)
f0102211:	85 d2                	test   %edx,%edx
f0102213:	a1 24 4e 11 f0       	mov    0xf0114e24,%eax
f0102218:	74 15                	je     f010222f <boot_alloc+0x3a>
        return nextfree;
    else if (n > 0)
    {
        result = nextfree;
        nextfree += ROUNDUP(n, PGSIZE);//find the nearest address which is nearest to address is be div by pagesize
f010221a:	81 c2 ff 0f 00 00    	add    $0xfff,%edx
f0102220:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0102226:	8d 14 10             	lea    (%eax,%edx,1),%edx
f0102229:	89 15 24 4e 11 f0    	mov    %edx,0xf0114e24
    }

	return result;
}
f010222f:	c3                   	ret    

f0102230 <_kaddr>:
	return (physaddr_t)kva - KERNBASE;
}

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
f0102230:	53                   	push   %ebx
	if (PGNUM(pa) >= npages)
f0102231:	89 cb                	mov    %ecx,%ebx
	return (physaddr_t)kva - KERNBASE;
}

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
f0102233:	83 ec 08             	sub    $0x8,%esp
	if (PGNUM(pa) >= npages)
f0102236:	c1 eb 0c             	shr    $0xc,%ebx
f0102239:	3b 1d c4 76 11 f0    	cmp    0xf01176c4,%ebx
f010223f:	72 0d                	jb     f010224e <_kaddr+0x1e>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0102241:	51                   	push   %ecx
f0102242:	68 9c 5a 10 f0       	push   $0xf0105a9c
f0102247:	52                   	push   %edx
f0102248:	50                   	push   %eax
f0102249:	e8 9a 19 00 00       	call   f0103be8 <_panic>
	return (void *)(pa + KERNBASE);
f010224e:	8d 81 00 00 00 f0    	lea    -0x10000000(%ecx),%eax
}
f0102254:	83 c4 08             	add    $0x8,%esp
f0102257:	5b                   	pop    %ebx
f0102258:	c3                   	ret    

f0102259 <page2kva>:
	return &pages[PGNUM(pa)];
}

static inline void*
page2kva(struct PageInfo *pp)
{
f0102259:	83 ec 0c             	sub    $0xc,%esp
	return KADDR(page2pa(pp));
f010225c:	e8 87 ff ff ff       	call   f01021e8 <page2pa>
f0102261:	ba 55 00 00 00       	mov    $0x55,%edx
}
f0102266:	83 c4 0c             	add    $0xc,%esp
}

static inline void*
page2kva(struct PageInfo *pp)
{
	return KADDR(page2pa(pp));
f0102269:	89 c1                	mov    %eax,%ecx
f010226b:	b8 bf 5a 10 f0       	mov    $0xf0105abf,%eax
f0102270:	eb be                	jmp    f0102230 <_kaddr>

f0102272 <check_va2pa>:
// this functionality for us!  We define our own version to help check
// the check_kern_pgdir() function; it shouldn't be used elsewhere.

static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
f0102272:	56                   	push   %esi
f0102273:	89 d6                	mov    %edx,%esi
f0102275:	53                   	push   %ebx
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
	if (!(*pgdir & PTE_P))
		return ~0;
f0102276:	83 cb ff             	or     $0xffffffff,%ebx
static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
f0102279:	c1 ea 16             	shr    $0x16,%edx
// this functionality for us!  We define our own version to help check
// the check_kern_pgdir() function; it shouldn't be used elsewhere.

static physaddr_t
check_va2pa(pde_t *pgdir, uintptr_t va)
{
f010227c:	83 ec 04             	sub    $0x4,%esp
	pte_t *p;

	pgdir = &pgdir[PDX(va)];
	if (!(*pgdir & PTE_P))
f010227f:	8b 0c 90             	mov    (%eax,%edx,4),%ecx
f0102282:	f6 c1 01             	test   $0x1,%cl
f0102285:	74 2e                	je     f01022b5 <check_va2pa+0x43>
		return ~0;
	p = (pte_t*) KADDR(PTE_ADDR(*pgdir));
f0102287:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f010228d:	ba 37 03 00 00       	mov    $0x337,%edx
f0102292:	b8 ce 5a 10 f0       	mov    $0xf0105ace,%eax
f0102297:	e8 94 ff ff ff       	call   f0102230 <_kaddr>
	if (!(p[PTX(va)] & PTE_P))
f010229c:	c1 ee 0c             	shr    $0xc,%esi
f010229f:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
f01022a5:	8b 04 b0             	mov    (%eax,%esi,4),%eax
		return ~0;
	return PTE_ADDR(p[PTX(va)]);
f01022a8:	89 c2                	mov    %eax,%edx
f01022aa:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f01022b0:	a8 01                	test   $0x1,%al
f01022b2:	0f 45 da             	cmovne %edx,%ebx
}
f01022b5:	89 d8                	mov    %ebx,%eax
f01022b7:	83 c4 04             	add    $0x4,%esp
f01022ba:	5b                   	pop    %ebx
f01022bb:	5e                   	pop    %esi
f01022bc:	c3                   	ret    

f01022bd <pa2page>:
	return (pp - pages) << PGSHIFT;
}

static inline struct PageInfo*
pa2page(physaddr_t pa)
{
f01022bd:	83 ec 0c             	sub    $0xc,%esp
	if (PGNUM(pa) >= npages)
f01022c0:	c1 e8 0c             	shr    $0xc,%eax
f01022c3:	3b 05 c4 76 11 f0    	cmp    0xf01176c4,%eax
f01022c9:	72 12                	jb     f01022dd <pa2page+0x20>
		panic("pa2page called with invalid pa");
f01022cb:	50                   	push   %eax
f01022cc:	68 db 5a 10 f0       	push   $0xf0105adb
f01022d1:	6a 4e                	push   $0x4e
f01022d3:	68 bf 5a 10 f0       	push   $0xf0105abf
f01022d8:	e8 0b 19 00 00       	call   f0103be8 <_panic>
	return &pages[PGNUM(pa)];
f01022dd:	c1 e0 03             	shl    $0x3,%eax
f01022e0:	03 05 d0 76 11 f0    	add    0xf01176d0,%eax
}
f01022e6:	83 c4 0c             	add    $0xc,%esp
f01022e9:	c3                   	ret    

f01022ea <check_page_free_list>:
//
// Check that the pages on the page_free_list are reasonable.
//
static void
check_page_free_list(bool only_low_memory)
{
f01022ea:	55                   	push   %ebp
f01022eb:	57                   	push   %edi
f01022ec:	56                   	push   %esi
f01022ed:	53                   	push   %ebx
f01022ee:	83 ec 1c             	sub    $0x1c,%esp
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
	int nfree_basemem = 0, nfree_extmem = 0;
	char *first_free_page;

	if (!page_free_list)
f01022f1:	8b 1d 1c 4e 11 f0    	mov    0xf0114e1c,%ebx
//
static void
check_page_free_list(bool only_low_memory)
{
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
f01022f7:	3c 01                	cmp    $0x1,%al
f01022f9:	19 f6                	sbb    %esi,%esi
f01022fb:	81 e6 ff 03 00 00    	and    $0x3ff,%esi
f0102301:	46                   	inc    %esi
	int nfree_basemem = 0, nfree_extmem = 0;
	char *first_free_page;

	if (!page_free_list)
f0102302:	85 db                	test   %ebx,%ebx
f0102304:	75 10                	jne    f0102316 <check_page_free_list+0x2c>
		panic("'page_free_list' is a null pointer!");
f0102306:	51                   	push   %ecx
f0102307:	68 fa 5a 10 f0       	push   $0xf0105afa
f010230c:	68 75 02 00 00       	push   $0x275
f0102311:	e9 b6 00 00 00       	jmp    f01023cc <check_page_free_list+0xe2>

	if (only_low_memory) {
f0102316:	84 c0                	test   %al,%al
f0102318:	74 4b                	je     f0102365 <check_page_free_list+0x7b>
		// Move pages with lower addresses first in the free
		// list, since entry_pgdir does not map all pages.
		struct PageInfo *pp1, *pp2;
		struct PageInfo **tp[2] = { &pp1, &pp2 };
f010231a:	8d 44 24 0c          	lea    0xc(%esp),%eax
f010231e:	89 04 24             	mov    %eax,(%esp)
f0102321:	8d 44 24 08          	lea    0x8(%esp),%eax
f0102325:	89 44 24 04          	mov    %eax,0x4(%esp)
		for (pp = page_free_list; pp; pp = pp->pp_link) {
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
f0102329:	89 d8                	mov    %ebx,%eax
f010232b:	e8 b8 fe ff ff       	call   f01021e8 <page2pa>
f0102330:	c1 e8 16             	shr    $0x16,%eax
f0102333:	39 f0                	cmp    %esi,%eax
f0102335:	0f 93 c0             	setae  %al
f0102338:	0f b6 c0             	movzbl %al,%eax
			*tp[pagetype] = pp;
f010233b:	8b 14 84             	mov    (%esp,%eax,4),%edx
f010233e:	89 1a                	mov    %ebx,(%edx)
			tp[pagetype] = &pp->pp_link;
f0102340:	89 1c 84             	mov    %ebx,(%esp,%eax,4)
	if (only_low_memory) {
		// Move pages with lower addresses first in the free
		// list, since entry_pgdir does not map all pages.
		struct PageInfo *pp1, *pp2;
		struct PageInfo **tp[2] = { &pp1, &pp2 };
		for (pp = page_free_list; pp; pp = pp->pp_link) {
f0102343:	8b 1b                	mov    (%ebx),%ebx
f0102345:	85 db                	test   %ebx,%ebx
f0102347:	75 e0                	jne    f0102329 <check_page_free_list+0x3f>
			int pagetype = PDX(page2pa(pp)) >= pdx_limit;
			*tp[pagetype] = pp;
			tp[pagetype] = &pp->pp_link;
		}
		*tp[1] = 0;
f0102349:	8b 44 24 04          	mov    0x4(%esp),%eax
f010234d:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
		*tp[0] = pp2;
f0102353:	8b 04 24             	mov    (%esp),%eax
f0102356:	8b 54 24 08          	mov    0x8(%esp),%edx
f010235a:	89 10                	mov    %edx,(%eax)
		page_free_list = pp1;
f010235c:	8b 44 24 0c          	mov    0xc(%esp),%eax
f0102360:	a3 1c 4e 11 f0       	mov    %eax,0xf0114e1c
	}

	// if there's a page that shouldn't be on the free list,
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0102365:	8b 1d 1c 4e 11 f0    	mov    0xf0114e1c,%ebx
f010236b:	eb 2b                	jmp    f0102398 <check_page_free_list+0xae>
		if (PDX(page2pa(pp)) < pdx_limit)
f010236d:	89 d8                	mov    %ebx,%eax
f010236f:	e8 74 fe ff ff       	call   f01021e8 <page2pa>
f0102374:	c1 e8 16             	shr    $0x16,%eax
f0102377:	39 f0                	cmp    %esi,%eax
f0102379:	73 1b                	jae    f0102396 <check_page_free_list+0xac>
			memset(page2kva(pp), 0x97, 128);
f010237b:	89 d8                	mov    %ebx,%eax
f010237d:	e8 d7 fe ff ff       	call   f0102259 <page2kva>
f0102382:	52                   	push   %edx
f0102383:	68 80 00 00 00       	push   $0x80
f0102388:	68 97 00 00 00       	push   $0x97
f010238d:	50                   	push   %eax
f010238e:	e8 3c de ff ff       	call   f01001cf <memset>
f0102393:	83 c4 10             	add    $0x10,%esp
		page_free_list = pp1;
	}

	// if there's a page that shouldn't be on the free list,
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0102396:	8b 1b                	mov    (%ebx),%ebx
f0102398:	85 db                	test   %ebx,%ebx
f010239a:	75 d1                	jne    f010236d <check_page_free_list+0x83>
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
f010239c:	31 c0                	xor    %eax,%eax
static void
check_page_free_list(bool only_low_memory)
{
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
	int nfree_basemem = 0, nfree_extmem = 0;
f010239e:	31 f6                	xor    %esi,%esi
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
f01023a0:	e8 50 fe ff ff       	call   f01021f5 <boot_alloc>
static void
check_page_free_list(bool only_low_memory)
{
	struct PageInfo *pp;
	unsigned pdx_limit = only_low_memory ? 1 : NPDENTRIES;
	int nfree_basemem = 0, nfree_extmem = 0;
f01023a5:	31 ff                	xor    %edi,%edi
	for (pp = page_free_list; pp; pp = pp->pp_link)
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f01023a7:	8b 1d 1c 4e 11 f0    	mov    0xf0114e1c,%ebx
	// try to make sure it eventually causes trouble.
	for (pp = page_free_list; pp; pp = pp->pp_link)
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
f01023ad:	89 c5                	mov    %eax,%ebp
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f01023af:	e9 ff 00 00 00       	jmp    f01024b3 <check_page_free_list+0x1c9>
		// check that we didn't corrupt the free list itself
		assert(pp >= pages);
f01023b4:	a1 d0 76 11 f0       	mov    0xf01176d0,%eax
f01023b9:	39 c3                	cmp    %eax,%ebx
f01023bb:	73 19                	jae    f01023d6 <check_page_free_list+0xec>
f01023bd:	68 1e 5b 10 f0       	push   $0xf0105b1e
f01023c2:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01023c7:	68 8f 02 00 00       	push   $0x28f
f01023cc:	68 ce 5a 10 f0       	push   $0xf0105ace
f01023d1:	e8 12 18 00 00       	call   f0103be8 <_panic>
		assert(pp < pages + npages);
f01023d6:	8b 15 c4 76 11 f0    	mov    0xf01176c4,%edx
f01023dc:	8d 14 d0             	lea    (%eax,%edx,8),%edx
f01023df:	39 d3                	cmp    %edx,%ebx
f01023e1:	72 11                	jb     f01023f4 <check_page_free_list+0x10a>
f01023e3:	68 3f 5b 10 f0       	push   $0xf0105b3f
f01023e8:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01023ed:	68 90 02 00 00       	push   $0x290
f01023f2:	eb d8                	jmp    f01023cc <check_page_free_list+0xe2>
		assert(((char *) pp - (char *) pages) % sizeof(*pp) == 0);
f01023f4:	89 da                	mov    %ebx,%edx
f01023f6:	29 c2                	sub    %eax,%edx
f01023f8:	89 d0                	mov    %edx,%eax
f01023fa:	a8 07                	test   $0x7,%al
f01023fc:	74 11                	je     f010240f <check_page_free_list+0x125>
f01023fe:	68 53 5b 10 f0       	push   $0xf0105b53
f0102403:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102408:	68 91 02 00 00       	push   $0x291
f010240d:	eb bd                	jmp    f01023cc <check_page_free_list+0xe2>

		// check a few pages that shouldn't be on the free list
		assert(page2pa(pp) != 0);
f010240f:	89 d8                	mov    %ebx,%eax
f0102411:	e8 d2 fd ff ff       	call   f01021e8 <page2pa>
f0102416:	85 c0                	test   %eax,%eax
f0102418:	75 11                	jne    f010242b <check_page_free_list+0x141>
f010241a:	68 85 5b 10 f0       	push   $0xf0105b85
f010241f:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102424:	68 94 02 00 00       	push   $0x294
f0102429:	eb a1                	jmp    f01023cc <check_page_free_list+0xe2>
		assert(page2pa(pp) != IOPHYSMEM);
f010242b:	3d 00 00 0a 00       	cmp    $0xa0000,%eax
f0102430:	75 11                	jne    f0102443 <check_page_free_list+0x159>
f0102432:	68 96 5b 10 f0       	push   $0xf0105b96
f0102437:	68 2a 5b 10 f0       	push   $0xf0105b2a
f010243c:	68 95 02 00 00       	push   $0x295
f0102441:	eb 89                	jmp    f01023cc <check_page_free_list+0xe2>
		assert(page2pa(pp) != EXTPHYSMEM - PGSIZE);
f0102443:	3d 00 f0 0f 00       	cmp    $0xff000,%eax
f0102448:	75 14                	jne    f010245e <check_page_free_list+0x174>
f010244a:	68 af 5b 10 f0       	push   $0xf0105baf
f010244f:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102454:	68 96 02 00 00       	push   $0x296
f0102459:	e9 6e ff ff ff       	jmp    f01023cc <check_page_free_list+0xe2>
		assert(page2pa(pp) != EXTPHYSMEM);
f010245e:	3d 00 00 10 00       	cmp    $0x100000,%eax
f0102463:	75 14                	jne    f0102479 <check_page_free_list+0x18f>
f0102465:	68 d2 5b 10 f0       	push   $0xf0105bd2
f010246a:	68 2a 5b 10 f0       	push   $0xf0105b2a
f010246f:	68 97 02 00 00       	push   $0x297
f0102474:	e9 53 ff ff ff       	jmp    f01023cc <check_page_free_list+0xe2>
		assert(page2pa(pp) < EXTPHYSMEM || (char *) page2kva(pp) >= first_free_page);
f0102479:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f010247e:	76 1f                	jbe    f010249f <check_page_free_list+0x1b5>
f0102480:	89 d8                	mov    %ebx,%eax
f0102482:	e8 d2 fd ff ff       	call   f0102259 <page2kva>
f0102487:	39 e8                	cmp    %ebp,%eax
f0102489:	73 14                	jae    f010249f <check_page_free_list+0x1b5>
f010248b:	68 ec 5b 10 f0       	push   $0xf0105bec
f0102490:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102495:	68 98 02 00 00       	push   $0x298
f010249a:	e9 2d ff ff ff       	jmp    f01023cc <check_page_free_list+0xe2>

		if (page2pa(pp) < EXTPHYSMEM)
f010249f:	89 d8                	mov    %ebx,%eax
f01024a1:	e8 42 fd ff ff       	call   f01021e8 <page2pa>
f01024a6:	3d ff ff 0f 00       	cmp    $0xfffff,%eax
f01024ab:	77 03                	ja     f01024b0 <check_page_free_list+0x1c6>
			++nfree_basemem;
f01024ad:	47                   	inc    %edi
f01024ae:	eb 01                	jmp    f01024b1 <check_page_free_list+0x1c7>
		else
			++nfree_extmem;
f01024b0:	46                   	inc    %esi
	for (pp = page_free_list; pp; pp = pp->pp_link)
		if (PDX(page2pa(pp)) < pdx_limit)
			memset(page2kva(pp), 0x97, 128);

	first_free_page = (char *) boot_alloc(0);
	for (pp = page_free_list; pp; pp = pp->pp_link) {
f01024b1:	8b 1b                	mov    (%ebx),%ebx
f01024b3:	85 db                	test   %ebx,%ebx
f01024b5:	0f 85 f9 fe ff ff    	jne    f01023b4 <check_page_free_list+0xca>
			++nfree_basemem;
		else
			++nfree_extmem;
	}

	assert(nfree_basemem > 0);
f01024bb:	85 ff                	test   %edi,%edi
f01024bd:	75 14                	jne    f01024d3 <check_page_free_list+0x1e9>
f01024bf:	68 31 5c 10 f0       	push   $0xf0105c31
f01024c4:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01024c9:	68 a0 02 00 00       	push   $0x2a0
f01024ce:	e9 f9 fe ff ff       	jmp    f01023cc <check_page_free_list+0xe2>
	assert(nfree_extmem > 0);
f01024d3:	85 f6                	test   %esi,%esi
f01024d5:	75 14                	jne    f01024eb <check_page_free_list+0x201>
f01024d7:	68 43 5c 10 f0       	push   $0xf0105c43
f01024dc:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01024e1:	68 a1 02 00 00       	push   $0x2a1
f01024e6:	e9 e1 fe ff ff       	jmp    f01023cc <check_page_free_list+0xe2>
	printk("check_page_free_list() succeeded!\n");
f01024eb:	83 ec 0c             	sub    $0xc,%esp
f01024ee:	68 54 5c 10 f0       	push   $0xf0105c54
f01024f3:	e8 d8 fc ff ff       	call   f01021d0 <printk>
}
f01024f8:	83 c4 2c             	add    $0x2c,%esp
f01024fb:	5b                   	pop    %ebx
f01024fc:	5e                   	pop    %esi
f01024fd:	5f                   	pop    %edi
f01024fe:	5d                   	pop    %ebp
f01024ff:	c3                   	ret    

f0102500 <nvram_read>:
// Detect machine's physical memory setup.
// --------------------------------------------------------------

static int
nvram_read(int r)
{
f0102500:	56                   	push   %esi
f0102501:	53                   	push   %ebx
f0102502:	89 c3                	mov    %eax,%ebx
f0102504:	83 ec 10             	sub    $0x10,%esp
  return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f0102507:	43                   	inc    %ebx
f0102508:	50                   	push   %eax
f0102509:	e8 5e 17 00 00       	call   f0103c6c <mc146818_read>
f010250e:	89 1c 24             	mov    %ebx,(%esp)
f0102511:	89 c6                	mov    %eax,%esi
f0102513:	e8 54 17 00 00       	call   f0103c6c <mc146818_read>
}
f0102518:	83 c4 14             	add    $0x14,%esp
f010251b:	5b                   	pop    %ebx
// --------------------------------------------------------------

static int
nvram_read(int r)
{
  return mc146818_read(r) | (mc146818_read(r + 1) << 8);
f010251c:	c1 e0 08             	shl    $0x8,%eax
f010251f:	09 f0                	or     %esi,%eax
}
f0102521:	5e                   	pop    %esi
f0102522:	c3                   	ret    

f0102523 <_paddr.clone.0>:


/* -------------- Inline Functions --------------  */

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
f0102523:	83 ec 0c             	sub    $0xc,%esp
{
	if ((uint32_t)kva < KERNBASE)
f0102526:	81 fa ff ff ff ef    	cmp    $0xefffffff,%edx
f010252c:	77 11                	ja     f010253f <_paddr.clone.0+0x1c>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f010252e:	52                   	push   %edx
f010252f:	68 c2 54 10 f0       	push   $0xf01054c2
f0102534:	50                   	push   %eax
f0102535:	68 ce 5a 10 f0       	push   $0xf0105ace
f010253a:	e8 a9 16 00 00       	call   f0103be8 <_panic>
	return (physaddr_t)kva - KERNBASE;
f010253f:	8d 82 00 00 00 10    	lea    0x10000000(%edx),%eax
}
f0102545:	83 c4 0c             	add    $0xc,%esp
f0102548:	c3                   	ret    

f0102549 <page_init>:
// allocator functions below to allocate and deallocate physical
// memory via the page_free_list.
//
void
page_init(void)
{
f0102549:	56                   	push   %esi
	// NB: DO NOT actually touch the physical memory corresponding to
	// free pages!
	
    /* TODO */
    size_t i;
	for (i = 0; i < npages; i++) {
f010254a:	31 f6                	xor    %esi,%esi
// allocator functions below to allocate and deallocate physical
// memory via the page_free_list.
//
void
page_init(void)
{
f010254c:	53                   	push   %ebx
	// NB: DO NOT actually touch the physical memory corresponding to
	// free pages!
	
    /* TODO */
    size_t i;
	for (i = 0; i < npages; i++) {
f010254d:	31 db                	xor    %ebx,%ebx
f010254f:	e9 82 00 00 00       	jmp    f01025d6 <page_init+0x8d>
        if(i ==0)
f0102554:	85 db                	test   %ebx,%ebx
f0102556:	75 11                	jne    f0102569 <page_init+0x20>
        {
            pages[i].pp_ref = 1; //from the hint tell us the 0 page is taken
f0102558:	a1 d0 76 11 f0       	mov    0xf01176d0,%eax
f010255d:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
            pages[i].pp_link=NULL;
f0102563:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        }
        if(i<npages_basemem)
f0102569:	3b 1d 20 4e 11 f0    	cmp    0xf0114e20,%ebx
f010256f:	73 1a                	jae    f010258b <page_init+0x42>
        {
            pages[i].pp_ref = 0;//free
f0102571:	a1 d0 76 11 f0       	mov    0xf01176d0,%eax
            pages[i].pp_link = page_free_list;
f0102576:	8b 15 1c 4e 11 f0    	mov    0xf0114e1c,%edx
            pages[i].pp_ref = 1; //from the hint tell us the 0 page is taken
            pages[i].pp_link=NULL;
        }
        if(i<npages_basemem)
        {
            pages[i].pp_ref = 0;//free
f010257c:	01 f0                	add    %esi,%eax
f010257e:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
            pages[i].pp_link = page_free_list;
f0102584:	89 10                	mov    %edx,(%eax)
            page_free_list = &pages[i];
f0102586:	a3 1c 4e 11 f0       	mov    %eax,0xf0114e1c
        }
        //(ext-io)/pg is number of io , the other is number of part of ext(kernel)
        if(i < ((EXTPHYSMEM-IOPHYSMEM)/PGSIZE) || i < ((uint32_t)boot_alloc(0)- KERNBASE)/PGSIZE)
f010258b:	83 fb 5f             	cmp    $0x5f,%ebx
f010258e:	76 13                	jbe    f01025a3 <page_init+0x5a>
f0102590:	31 c0                	xor    %eax,%eax
f0102592:	e8 5e fc ff ff       	call   f01021f5 <boot_alloc>
f0102597:	05 00 00 00 10       	add    $0x10000000,%eax
f010259c:	c1 e8 0c             	shr    $0xc,%eax
f010259f:	39 c3                	cmp    %eax,%ebx
f01025a1:	73 15                	jae    f01025b8 <page_init+0x6f>
        {
            pages[i].pp_ref = 1; //from the hint tell us the 0 page is taken
f01025a3:	a1 d0 76 11 f0       	mov    0xf01176d0,%eax
f01025a8:	01 f0                	add    %esi,%eax
f01025aa:	66 c7 40 04 01 00    	movw   $0x1,0x4(%eax)
            pages[i].pp_link=NULL;
f01025b0:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
f01025b6:	eb 1a                	jmp    f01025d2 <page_init+0x89>
        }
        else
        {
            pages[i].pp_ref = 0;
f01025b8:	a1 d0 76 11 f0       	mov    0xf01176d0,%eax
            pages[i].pp_link = page_free_list;
f01025bd:	8b 15 1c 4e 11 f0    	mov    0xf0114e1c,%edx
            pages[i].pp_ref = 1; //from the hint tell us the 0 page is taken
            pages[i].pp_link=NULL;
        }
        else
        {
            pages[i].pp_ref = 0;
f01025c3:	01 f0                	add    %esi,%eax
f01025c5:	66 c7 40 04 00 00    	movw   $0x0,0x4(%eax)
            pages[i].pp_link = page_free_list;
f01025cb:	89 10                	mov    %edx,(%eax)
            page_free_list = &pages[i];
f01025cd:	a3 1c 4e 11 f0       	mov    %eax,0xf0114e1c
	// NB: DO NOT actually touch the physical memory corresponding to
	// free pages!
	
    /* TODO */
    size_t i;
	for (i = 0; i < npages; i++) {
f01025d2:	43                   	inc    %ebx
f01025d3:	83 c6 08             	add    $0x8,%esi
f01025d6:	3b 1d c4 76 11 f0    	cmp    0xf01176c4,%ebx
f01025dc:	0f 82 72 ff ff ff    	jb     f0102554 <page_init+0xb>
            pages[i].pp_ref = 0;
            pages[i].pp_link = page_free_list;
            page_free_list = &pages[i];
        }
    }
}
f01025e2:	5b                   	pop    %ebx
f01025e3:	5e                   	pop    %esi
f01025e4:	c3                   	ret    

f01025e5 <page_alloc>:
// Returns NULL if out of free memory.
//
// Hint: use page2kva and memset
struct PageInfo *
page_alloc(int alloc_flags)
{
f01025e5:	53                   	push   %ebx
f01025e6:	83 ec 08             	sub    $0x8,%esp
    /* TODO */
    if(!page_free_list)
f01025e9:	8b 1d 1c 4e 11 f0    	mov    0xf0114e1c,%ebx
f01025ef:	85 db                	test   %ebx,%ebx
f01025f1:	74 2c                	je     f010261f <page_alloc+0x3a>
        return NULL;
    struct PageInfo *newpage;
    newpage = page_free_list;
    page_free_list = newpage->pp_link;
f01025f3:	8b 03                	mov    (%ebx),%eax
    newpage->pp_link = NULL;
    //get the page and let the link to next page


    if(alloc_flags & ALLOC_ZERO)
f01025f5:	f6 44 24 10 01       	testb  $0x1,0x10(%esp)
    if(!page_free_list)
        return NULL;
    struct PageInfo *newpage;
    newpage = page_free_list;
    page_free_list = newpage->pp_link;
    newpage->pp_link = NULL;
f01025fa:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
    /* TODO */
    if(!page_free_list)
        return NULL;
    struct PageInfo *newpage;
    newpage = page_free_list;
    page_free_list = newpage->pp_link;
f0102600:	a3 1c 4e 11 f0       	mov    %eax,0xf0114e1c
    newpage->pp_link = NULL;
    //get the page and let the link to next page


    if(alloc_flags & ALLOC_ZERO)
f0102605:	74 18                	je     f010261f <page_alloc+0x3a>
         memset(page2kva(newpage),'\0',PGSIZE);
f0102607:	89 d8                	mov    %ebx,%eax
f0102609:	e8 4b fc ff ff       	call   f0102259 <page2kva>
f010260e:	52                   	push   %edx
f010260f:	68 00 10 00 00       	push   $0x1000
f0102614:	6a 00                	push   $0x0
f0102616:	50                   	push   %eax
f0102617:	e8 b3 db ff ff       	call   f01001cf <memset>
f010261c:	83 c4 10             	add    $0x10,%esp
         return newpage;
}
f010261f:	89 d8                	mov    %ebx,%eax
f0102621:	83 c4 08             	add    $0x8,%esp
f0102624:	5b                   	pop    %ebx
f0102625:	c3                   	ret    

f0102626 <page_free>:
// Return a page to the free list.
// (This function should only be called when pp->pp_ref reaches 0.)
//
void
page_free(struct PageInfo *pp)
{
f0102626:	83 ec 0c             	sub    $0xc,%esp
f0102629:	8b 44 24 10          	mov    0x10(%esp),%eax
	// Fill this function in
	// Hint: You may want to panic if pp->pp_ref is nonzero or
	// pp->pp_link is not NULL.
    /* TODO */
    if(pp->pp_link != NULL || pp->pp_ref != 0)
f010262d:	83 38 00             	cmpl   $0x0,(%eax)
f0102630:	75 07                	jne    f0102639 <page_free+0x13>
f0102632:	66 83 78 04 00       	cmpw   $0x0,0x4(%eax)
f0102637:	74 15                	je     f010264e <page_free+0x28>
    {
        panic("the page can't return free");
f0102639:	51                   	push   %ecx
f010263a:	68 77 5c 10 f0       	push   $0xf0105c77
f010263f:	68 51 01 00 00       	push   $0x151
f0102644:	68 ce 5a 10 f0       	push   $0xf0105ace
f0102649:	e8 9a 15 00 00       	call   f0103be8 <_panic>
        return;
    }   
    pp->pp_link = page_free_list;
f010264e:	8b 15 1c 4e 11 f0    	mov    0xf0114e1c,%edx
    page_free_list = pp;
f0102654:	a3 1c 4e 11 f0       	mov    %eax,0xf0114e1c
    if(pp->pp_link != NULL || pp->pp_ref != 0)
    {
        panic("the page can't return free");
        return;
    }   
    pp->pp_link = page_free_list;
f0102659:	89 10                	mov    %edx,(%eax)
    page_free_list = pp;
}
f010265b:	83 c4 0c             	add    $0xc,%esp
f010265e:	c3                   	ret    

f010265f <page_decref>:
// Decrement the reference count on a page,
// freeing it if there are no more refs.
//
void
page_decref(struct PageInfo* pp)
{
f010265f:	83 ec 0c             	sub    $0xc,%esp
f0102662:	8b 44 24 10          	mov    0x10(%esp),%eax
	if (--pp->pp_ref == 0)
f0102666:	8b 50 04             	mov    0x4(%eax),%edx
f0102669:	4a                   	dec    %edx
f010266a:	66 85 d2             	test   %dx,%dx
f010266d:	66 89 50 04          	mov    %dx,0x4(%eax)
f0102671:	75 08                	jne    f010267b <page_decref+0x1c>
		page_free(pp);
}
f0102673:	83 c4 0c             	add    $0xc,%esp
//
void
page_decref(struct PageInfo* pp)
{
	if (--pp->pp_ref == 0)
		page_free(pp);
f0102676:	e9 ab ff ff ff       	jmp    f0102626 <page_free>
}
f010267b:	83 c4 0c             	add    $0xc,%esp
f010267e:	c3                   	ret    

f010267f <pgdir_walk>:
//
//check a va which have pte?if has ,return it
//if no we create
pte_t *
pgdir_walk(pde_t *pgdir, const void *va, int create)
{
f010267f:	57                   	push   %edi
f0102680:	56                   	push   %esi
f0102681:	53                   	push   %ebx
f0102682:	8b 5c 24 14          	mov    0x14(%esp),%ebx
	// Fill this function in
    /* TODO */
    int pagedir_index = PDX(va);
f0102686:	89 de                	mov    %ebx,%esi
f0102688:	c1 ee 16             	shr    $0x16,%esi
    int pagetable_index = PTX(va);
    //chech the page table entry which is in memory?

    if(!(pgdir[pagedir_index] & PTE_P)){//check the page table(the offset if padir) that can present(inc/mmu.h)
f010268b:	c1 e6 02             	shl    $0x2,%esi
f010268e:	03 74 24 10          	add    0x10(%esp),%esi
f0102692:	8b 3e                	mov    (%esi),%edi
f0102694:	83 e7 01             	and    $0x1,%edi
f0102697:	75 2a                	jne    f01026c3 <pgdir_walk+0x44>
                return NULL;//return false
            page->pp_ref++;
            pgdir[pagedir_index] =( page2pa(page) | PTE_P | PTE_U | PTE_W); //present read/write user/kernel can use , all OR with page2pa
        }
        else 
            return NULL;
f0102699:	31 d2                	xor    %edx,%edx
    int pagedir_index = PDX(va);
    int pagetable_index = PTX(va);
    //chech the page table entry which is in memory?

    if(!(pgdir[pagedir_index] & PTE_P)){//check the page table(the offset if padir) that can present(inc/mmu.h)
        if(create){
f010269b:	83 7c 24 18 00       	cmpl   $0x0,0x18(%esp)
f01026a0:	74 44                	je     f01026e6 <pgdir_walk+0x67>
            struct PageInfo *page = page_alloc(ALLOC_ZERO);//a zero page
f01026a2:	83 ec 0c             	sub    $0xc,%esp
f01026a5:	6a 01                	push   $0x1
f01026a7:	e8 39 ff ff ff       	call   f01025e5 <page_alloc>
            if(!page)
f01026ac:	83 c4 10             	add    $0x10,%esp
                return NULL;//return false
f01026af:	89 fa                	mov    %edi,%edx
    //chech the page table entry which is in memory?

    if(!(pgdir[pagedir_index] & PTE_P)){//check the page table(the offset if padir) that can present(inc/mmu.h)
        if(create){
            struct PageInfo *page = page_alloc(ALLOC_ZERO);//a zero page
            if(!page)
f01026b1:	85 c0                	test   %eax,%eax
f01026b3:	74 31                	je     f01026e6 <pgdir_walk+0x67>
                return NULL;//return false
            page->pp_ref++;
f01026b5:	66 ff 40 04          	incw   0x4(%eax)
            pgdir[pagedir_index] =( page2pa(page) | PTE_P | PTE_U | PTE_W); //present read/write user/kernel can use , all OR with page2pa
f01026b9:	e8 2a fb ff ff       	call   f01021e8 <page2pa>
f01026be:	83 c8 07             	or     $0x7,%eax
f01026c1:	89 06                	mov    %eax,(%esi)
        }
        else 
            return NULL;
    }
    pte_t *result;
    result = KADDR(PTE_ADDR(pgdir[pagedir_index]));//PTE_ADDR , the address of page table or dir,inc/mmu.h,KADDR is phy addr to kernel viruial addr , kernel/mem.h
f01026c3:	8b 0e                	mov    (%esi),%ecx
f01026c5:	ba 92 01 00 00       	mov    $0x192,%edx
f01026ca:	b8 ce 5a 10 f0       	mov    $0xf0105ace,%eax
pgdir_walk(pde_t *pgdir, const void *va, int create)
{
	// Fill this function in
    /* TODO */
    int pagedir_index = PDX(va);
    int pagetable_index = PTX(va);
f01026cf:	c1 eb 0a             	shr    $0xa,%ebx
        else 
            return NULL;
    }
    pte_t *result;
    result = KADDR(PTE_ADDR(pgdir[pagedir_index]));//PTE_ADDR , the address of page table or dir,inc/mmu.h,KADDR is phy addr to kernel viruial addr , kernel/mem.h
    return &result[pagetable_index];
f01026d2:	81 e3 fc 0f 00 00    	and    $0xffc,%ebx
        }
        else 
            return NULL;
    }
    pte_t *result;
    result = KADDR(PTE_ADDR(pgdir[pagedir_index]));//PTE_ADDR , the address of page table or dir,inc/mmu.h,KADDR is phy addr to kernel viruial addr , kernel/mem.h
f01026d8:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f01026de:	e8 4d fb ff ff       	call   f0102230 <_kaddr>
    return &result[pagetable_index];
f01026e3:	8d 14 18             	lea    (%eax,%ebx,1),%edx
}
f01026e6:	89 d0                	mov    %edx,%eax
f01026e8:	5b                   	pop    %ebx
f01026e9:	5e                   	pop    %esi
f01026ea:	5f                   	pop    %edi
f01026eb:	c3                   	ret    

f01026ec <boot_map_region>:
// mapped pages.
//
// Hint: the TA solution uses pgdir_walk
static void
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)//perm means permission
{
f01026ec:	55                   	push   %ebp
f01026ed:	89 cd                	mov    %ecx,%ebp
f01026ef:	57                   	push   %edi
    /* TODO */
    pte_t *pte;
    int i;
    for (i = 0; i < size/PGSIZE; i++)
f01026f0:	31 ff                	xor    %edi,%edi
// mapped pages.
//
// Hint: the TA solution uses pgdir_walk
static void
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)//perm means permission
{
f01026f2:	56                   	push   %esi
f01026f3:	89 d6                	mov    %edx,%esi
f01026f5:	53                   	push   %ebx
f01026f6:	89 c3                	mov    %eax,%ebx
f01026f8:	83 ec 0c             	sub    $0xc,%esp
    /* TODO */
    pte_t *pte;
    int i;
    for (i = 0; i < size/PGSIZE; i++)
f01026fb:	c1 ed 0c             	shr    $0xc,%ebp
    {
        pte = pgdir_walk(pgdir,(void*)va,1);//1 mean create 
        *pte = (pa | perm | PTE_P);
f01026fe:	83 4c 24 24 01       	orl    $0x1,0x24(%esp)
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)//perm means permission
{
    /* TODO */
    pte_t *pte;
    int i;
    for (i = 0; i < size/PGSIZE; i++)
f0102703:	eb 26                	jmp    f010272b <boot_map_region+0x3f>
    {
        pte = pgdir_walk(pgdir,(void*)va,1);//1 mean create 
f0102705:	50                   	push   %eax
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)//perm means permission
{
    /* TODO */
    pte_t *pte;
    int i;
    for (i = 0; i < size/PGSIZE; i++)
f0102706:	47                   	inc    %edi
    {
        pte = pgdir_walk(pgdir,(void*)va,1);//1 mean create 
f0102707:	6a 01                	push   $0x1
f0102709:	56                   	push   %esi
        *pte = (pa | perm | PTE_P);
        pa += PGSIZE;
        va += PGSIZE;
f010270a:	81 c6 00 10 00 00    	add    $0x1000,%esi
    /* TODO */
    pte_t *pte;
    int i;
    for (i = 0; i < size/PGSIZE; i++)
    {
        pte = pgdir_walk(pgdir,(void*)va,1);//1 mean create 
f0102710:	53                   	push   %ebx
f0102711:	e8 69 ff ff ff       	call   f010267f <pgdir_walk>
        *pte = (pa | perm | PTE_P);
f0102716:	8b 54 24 34          	mov    0x34(%esp),%edx
f010271a:	0b 54 24 30          	or     0x30(%esp),%edx
f010271e:	89 10                	mov    %edx,(%eax)
        pa += PGSIZE;
f0102720:	81 44 24 30 00 10 00 	addl   $0x1000,0x30(%esp)
f0102727:	00 
boot_map_region(pde_t *pgdir, uintptr_t va, size_t size, physaddr_t pa, int perm)//perm means permission
{
    /* TODO */
    pte_t *pte;
    int i;
    for (i = 0; i < size/PGSIZE; i++)
f0102728:	83 c4 10             	add    $0x10,%esp
f010272b:	39 ef                	cmp    %ebp,%edi
f010272d:	72 d6                	jb     f0102705 <boot_map_region+0x19>
        *pte = (pa | perm | PTE_P);
        pa += PGSIZE;
        va += PGSIZE;
    }
    
}
f010272f:	83 c4 0c             	add    $0xc,%esp
f0102732:	5b                   	pop    %ebx
f0102733:	5e                   	pop    %esi
f0102734:	5f                   	pop    %edi
f0102735:	5d                   	pop    %ebp
f0102736:	c3                   	ret    

f0102737 <page_lookup>:
//
// Hint: the TA solution uses pgdir_walk and pa2page.
//
struct PageInfo *
page_lookup(pde_t *pgdir, void *va, pte_t **pte_store)
{
f0102737:	53                   	push   %ebx
f0102738:	83 ec 0c             	sub    $0xc,%esp
f010273b:	8b 5c 24 1c          	mov    0x1c(%esp),%ebx
    /* TODO */
    pte_t *pte=pgdir_walk(pgdir,(void *)va,0);
f010273f:	6a 00                	push   $0x0
f0102741:	ff 74 24 1c          	pushl  0x1c(%esp)
f0102745:	ff 74 24 1c          	pushl  0x1c(%esp)
f0102749:	e8 31 ff ff ff       	call   f010267f <pgdir_walk>
    if(pte==NULL)
f010274e:	83 c4 10             	add    $0x10,%esp
f0102751:	85 c0                	test   %eax,%eax
f0102753:	74 1d                	je     f0102772 <page_lookup+0x3b>
        return NULL;
    if(!(*pte & PTE_P))
f0102755:	8b 10                	mov    (%eax),%edx
f0102757:	f6 c2 01             	test   $0x1,%dl
f010275a:	74 16                	je     f0102772 <page_lookup+0x3b>
        return NULL;
    if(pte_store)
f010275c:	85 db                	test   %ebx,%ebx
f010275e:	74 02                	je     f0102762 <page_lookup+0x2b>
        *pte_store = pte;//if pte_store is not zero ,then put the pde to the pte_store
f0102760:	89 03                	mov    %eax,(%ebx)
    return pa2page(PTE_ADDR(*pte));
}
f0102762:	83 c4 08             	add    $0x8,%esp
        return NULL;
    if(!(*pte & PTE_P))
        return NULL;
    if(pte_store)
        *pte_store = pte;//if pte_store is not zero ,then put the pde to the pte_store
    return pa2page(PTE_ADDR(*pte));
f0102765:	89 d0                	mov    %edx,%eax
}
f0102767:	5b                   	pop    %ebx
        return NULL;
    if(!(*pte & PTE_P))
        return NULL;
    if(pte_store)
        *pte_store = pte;//if pte_store is not zero ,then put the pde to the pte_store
    return pa2page(PTE_ADDR(*pte));
f0102768:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f010276d:	e9 4b fb ff ff       	jmp    f01022bd <pa2page>
}
f0102772:	31 c0                	xor    %eax,%eax
f0102774:	83 c4 08             	add    $0x8,%esp
f0102777:	5b                   	pop    %ebx
f0102778:	c3                   	ret    

f0102779 <page_remove>:
// Hint: The TA solution is implemented using page_lookup,
// 	tlb_invalidate, and page_decref.
//
void
page_remove(pde_t *pgdir, void *va)
{
f0102779:	53                   	push   %ebx
f010277a:	83 ec 1c             	sub    $0x1c,%esp
f010277d:	8b 5c 24 28          	mov    0x28(%esp),%ebx
    /* TODO */
    pte_t *pte;
    struct PageInfo *page = page_lookup(pgdir,(void *)va,&pte);
f0102781:	8d 44 24 10          	lea    0x10(%esp),%eax
f0102785:	50                   	push   %eax
f0102786:	53                   	push   %ebx
f0102787:	ff 74 24 2c          	pushl  0x2c(%esp)
f010278b:	e8 a7 ff ff ff       	call   f0102737 <page_lookup>
    if(page == NULL)
f0102790:	83 c4 10             	add    $0x10,%esp
f0102793:	85 c0                	test   %eax,%eax
f0102795:	74 19                	je     f01027b0 <page_remove+0x37>
        return NULL;
    page_decref(page);
f0102797:	83 ec 0c             	sub    $0xc,%esp
f010279a:	50                   	push   %eax
f010279b:	e8 bf fe ff ff       	call   f010265f <page_decref>
    *pte = 0;//the page table entry set to 0
f01027a0:	8b 44 24 1c          	mov    0x1c(%esp),%eax
f01027a4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}

static __inline void
invlpg(void *addr)
{
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
f01027aa:	0f 01 3b             	invlpg (%ebx)
f01027ad:	83 c4 10             	add    $0x10,%esp
    tlb_invalidate(pgdir, va);
}
f01027b0:	83 c4 18             	add    $0x18,%esp
f01027b3:	5b                   	pop    %ebx
f01027b4:	c3                   	ret    

f01027b5 <page_insert>:
// Hint: The TA solution is implemented using pgdir_walk, page_remove,
// and page2pa.
//
int
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)
{
f01027b5:	55                   	push   %ebp
f01027b6:	57                   	push   %edi
f01027b7:	56                   	push   %esi
f01027b8:	53                   	push   %ebx
f01027b9:	83 ec 10             	sub    $0x10,%esp
f01027bc:	8b 6c 24 2c          	mov    0x2c(%esp),%ebp
f01027c0:	8b 7c 24 24          	mov    0x24(%esp),%edi
f01027c4:	8b 74 24 28          	mov    0x28(%esp),%esi
    
    /* TODO */
    
    pte_t *pte = pgdir_walk(pgdir,(void *)va,1);
f01027c8:	6a 01                	push   $0x1
f01027ca:	55                   	push   %ebp
f01027cb:	57                   	push   %edi
f01027cc:	e8 ae fe ff ff       	call   f010267f <pgdir_walk>
    if(pte==NULL)
f01027d1:	83 c4 10             	add    $0x10,%esp
page_insert(pde_t *pgdir, struct PageInfo *pp, void *va, int perm)
{
    
    /* TODO */
    
    pte_t *pte = pgdir_walk(pgdir,(void *)va,1);
f01027d4:	89 c3                	mov    %eax,%ebx
    if(pte==NULL)
        return -E_NO_MEM;
f01027d6:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
{
    
    /* TODO */
    
    pte_t *pte = pgdir_walk(pgdir,(void *)va,1);
    if(pte==NULL)
f01027db:	85 db                	test   %ebx,%ebx
f01027dd:	74 29                	je     f0102808 <page_insert+0x53>
        return -E_NO_MEM;
    pp->pp_ref++;
f01027df:	66 ff 46 04          	incw   0x4(%esi)
    if(*pte &PTE_P)
f01027e3:	f6 03 01             	testb  $0x1,(%ebx)
f01027e6:	74 0c                	je     f01027f4 <page_insert+0x3f>
        page_remove(pgdir,va);
f01027e8:	52                   	push   %edx
f01027e9:	52                   	push   %edx
f01027ea:	55                   	push   %ebp
f01027eb:	57                   	push   %edi
f01027ec:	e8 88 ff ff ff       	call   f0102779 <page_remove>
f01027f1:	83 c4 10             	add    $0x10,%esp
    *pte = page2pa(pp) | perm | PTE_P;
f01027f4:	89 f0                	mov    %esi,%eax
f01027f6:	e8 ed f9 ff ff       	call   f01021e8 <page2pa>
f01027fb:	8b 54 24 2c          	mov    0x2c(%esp),%edx
f01027ff:	83 ca 01             	or     $0x1,%edx
f0102802:	09 c2                	or     %eax,%edx
    return 0;
f0102804:	31 c0                	xor    %eax,%eax
    if(pte==NULL)
        return -E_NO_MEM;
    pp->pp_ref++;
    if(*pte &PTE_P)
        page_remove(pgdir,va);
    *pte = page2pa(pp) | perm | PTE_P;
f0102806:	89 13                	mov    %edx,(%ebx)
    return 0;
    
}
f0102808:	83 c4 0c             	add    $0xc,%esp
f010280b:	5b                   	pop    %ebx
f010280c:	5e                   	pop    %esi
f010280d:	5f                   	pop    %edi
f010280e:	5d                   	pop    %ebp
f010280f:	c3                   	ret    

f0102810 <mem_init>:
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
{
f0102810:	55                   	push   %ebp
{
  size_t npages_extmem;

  // Use CMOS calls to measure available base & extended memory.
  // (CMOS calls return results in kilobytes.)
  npages_basemem = (nvram_read(NVRAM_BASELO) * 1024) / PGSIZE;
f0102811:	b8 15 00 00 00       	mov    $0x15,%eax
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
{
f0102816:	57                   	push   %edi
f0102817:	56                   	push   %esi
f0102818:	53                   	push   %ebx
{
  size_t npages_extmem;

  // Use CMOS calls to measure available base & extended memory.
  // (CMOS calls return results in kilobytes.)
  npages_basemem = (nvram_read(NVRAM_BASELO) * 1024) / PGSIZE;
f0102819:	bb 04 00 00 00       	mov    $0x4,%ebx
//
// From UTOP to ULIM, the user is allowed to read but not write.
// Above ULIM the user cannot read or write.
void
mem_init(void)
{
f010281e:	83 ec 2c             	sub    $0x2c,%esp
	uint32_t cr0;
    nextfree = 0;
f0102821:	c7 05 24 4e 11 f0 00 	movl   $0x0,0xf0114e24
f0102828:	00 00 00 
    page_free_list = 0;
f010282b:	c7 05 1c 4e 11 f0 00 	movl   $0x0,0xf0114e1c
f0102832:	00 00 00 
{
  size_t npages_extmem;

  // Use CMOS calls to measure available base & extended memory.
  // (CMOS calls return results in kilobytes.)
  npages_basemem = (nvram_read(NVRAM_BASELO) * 1024) / PGSIZE;
f0102835:	e8 c6 fc ff ff       	call   f0102500 <nvram_read>
f010283a:	99                   	cltd   
f010283b:	f7 fb                	idiv   %ebx
f010283d:	a3 20 4e 11 f0       	mov    %eax,0xf0114e20
  npages_extmem = (nvram_read(NVRAM_EXTLO) * 1024) / PGSIZE;
f0102842:	b8 17 00 00 00       	mov    $0x17,%eax
f0102847:	e8 b4 fc ff ff       	call   f0102500 <nvram_read>
f010284c:	99                   	cltd   
f010284d:	f7 fb                	idiv   %ebx

  // Calculate the number of physical pages available in both base
  // and extended memory.
  if (npages_extmem)
f010284f:	85 c0                	test   %eax,%eax
    npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
f0102851:	8d 90 00 01 00 00    	lea    0x100(%eax),%edx
  npages_basemem = (nvram_read(NVRAM_BASELO) * 1024) / PGSIZE;
  npages_extmem = (nvram_read(NVRAM_EXTLO) * 1024) / PGSIZE;

  // Calculate the number of physical pages available in both base
  // and extended memory.
  if (npages_extmem)
f0102857:	75 06                	jne    f010285f <mem_init+0x4f>
    npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
  else
    npages = npages_basemem;
f0102859:	8b 15 20 4e 11 f0    	mov    0xf0114e20,%edx

  printk("Physical memory: %uK available, base = %uK, extended = %uK\n",
      npages * PGSIZE / 1024,
      npages_basemem * PGSIZE / 1024,
      npages_extmem * PGSIZE / 1024);
f010285f:	c1 e0 0c             	shl    $0xc,%eax
  if (npages_extmem)
    npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
  else
    npages = npages_basemem;

  printk("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0102862:	c1 e8 0a             	shr    $0xa,%eax
f0102865:	50                   	push   %eax
      npages * PGSIZE / 1024,
      npages_basemem * PGSIZE / 1024,
f0102866:	a1 20 4e 11 f0       	mov    0xf0114e20,%eax
  // Calculate the number of physical pages available in both base
  // and extended memory.
  if (npages_extmem)
    npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
  else
    npages = npages_basemem;
f010286b:	89 15 c4 76 11 f0    	mov    %edx,0xf01176c4

  printk("Physical memory: %uK available, base = %uK, extended = %uK\n",
      npages * PGSIZE / 1024,
      npages_basemem * PGSIZE / 1024,
f0102871:	c1 e0 0c             	shl    $0xc,%eax
  if (npages_extmem)
    npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
  else
    npages = npages_basemem;

  printk("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0102874:	c1 e8 0a             	shr    $0xa,%eax
f0102877:	50                   	push   %eax
      npages * PGSIZE / 1024,
f0102878:	a1 c4 76 11 f0       	mov    0xf01176c4,%eax
f010287d:	c1 e0 0c             	shl    $0xc,%eax
  if (npages_extmem)
    npages = (EXTPHYSMEM / PGSIZE) + npages_extmem;
  else
    npages = npages_basemem;

  printk("Physical memory: %uK available, base = %uK, extended = %uK\n",
f0102880:	c1 e8 0a             	shr    $0xa,%eax
f0102883:	50                   	push   %eax
f0102884:	68 92 5c 10 f0       	push   $0xf0105c92
f0102889:	e8 42 f9 ff ff       	call   f01021d0 <printk>
	// Find out how much memory the machine has (npages & npages_basemem).
	i386_detect_memory();//get the number of membase page(can be used) ,io hole page(not) ,extmem page(ok)

	//////////////////////////////////////////////////////////////////////
	//!!! create initial page directory.
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);//in inc/mmu.h PGSIZE is 4096b = 4KB
f010288e:	b8 00 10 00 00       	mov    $0x1000,%eax
f0102893:	e8 5d f9 ff ff       	call   f01021f5 <boot_alloc>
	memset(kern_pgdir, 0, PGSIZE);//memset(start addr , content, size)
f0102898:	83 c4 0c             	add    $0xc,%esp
f010289b:	68 00 10 00 00       	push   $0x1000
f01028a0:	6a 00                	push   $0x0
f01028a2:	50                   	push   %eax
	// Find out how much memory the machine has (npages & npages_basemem).
	i386_detect_memory();//get the number of membase page(can be used) ,io hole page(not) ,extmem page(ok)

	//////////////////////////////////////////////////////////////////////
	//!!! create initial page directory.
	kern_pgdir = (pde_t *) boot_alloc(PGSIZE);//in inc/mmu.h PGSIZE is 4096b = 4KB
f01028a3:	a3 c8 76 11 f0       	mov    %eax,0xf01176c8
	memset(kern_pgdir, 0, PGSIZE);//memset(start addr , content, size)
f01028a8:	e8 22 d9 ff ff       	call   f01001cf <memset>
	// (For now, you don't have understand the greater purpose of the
	// following line.)

	// Permissions: kernel R, user R
    // UVPT is a virtual address in memlayout.h , the address is map to the kern_pgdir(physcial addr)
	kern_pgdir[PDX(UVPT)] = PADDR(kern_pgdir) | PTE_U | PTE_P;
f01028ad:	8b 1d c8 76 11 f0    	mov    0xf01176c8,%ebx
f01028b3:	b8 90 00 00 00       	mov    $0x90,%eax
f01028b8:	89 da                	mov    %ebx,%edx
f01028ba:	e8 64 fc ff ff       	call   f0102523 <_paddr.clone.0>
f01028bf:	83 c8 05             	or     $0x5,%eax
f01028c2:	89 83 f4 0e 00 00    	mov    %eax,0xef4(%ebx)
	// each physical page, there is a corresponding struct PageInfo in this
	// array.  'npages' is the number of physical pages in memory.  Use memset
	// to initialize all fields of each struct PageInfo to 0.
	// Your code goes here:
    /* TODO */
    pages = (struct PageInfo *)boot_alloc(sizeof(struct PageInfo)*npages);
f01028c8:	a1 c4 76 11 f0       	mov    0xf01176c4,%eax
f01028cd:	c1 e0 03             	shl    $0x3,%eax
f01028d0:	e8 20 f9 ff ff       	call   f01021f5 <boot_alloc>
    memset(pages,0,npages*(sizeof(struct PageInfo)));
f01028d5:	8b 15 c4 76 11 f0    	mov    0xf01176c4,%edx
f01028db:	83 c4 0c             	add    $0xc,%esp
f01028de:	c1 e2 03             	shl    $0x3,%edx
f01028e1:	52                   	push   %edx
f01028e2:	6a 00                	push   $0x0
f01028e4:	50                   	push   %eax
	// each physical page, there is a corresponding struct PageInfo in this
	// array.  'npages' is the number of physical pages in memory.  Use memset
	// to initialize all fields of each struct PageInfo to 0.
	// Your code goes here:
    /* TODO */
    pages = (struct PageInfo *)boot_alloc(sizeof(struct PageInfo)*npages);
f01028e5:	a3 d0 76 11 f0       	mov    %eax,0xf01176d0
    memset(pages,0,npages*(sizeof(struct PageInfo)));
f01028ea:	e8 e0 d8 ff ff       	call   f01001cf <memset>
	// Now that we've allocated the initial kernel data structures, we set
	// up the list of free physical pages. Once we've done so, all further
	// memory management will go through the page_* functions. In
	// particular, we can now map memory using boot_map_region
	// or page_insert
	page_init();
f01028ef:	e8 55 fc ff ff       	call   f0102549 <page_init>

	check_page_free_list(1);
f01028f4:	b8 01 00 00 00       	mov    $0x1,%eax
f01028f9:	e8 ec f9 ff ff       	call   f01022ea <check_page_free_list>
	int nfree;
	struct PageInfo *fl;
	char *c;
	int i;

	if (!pages)
f01028fe:	83 c4 10             	add    $0x10,%esp
f0102901:	83 3d d0 76 11 f0 00 	cmpl   $0x0,0xf01176d0
f0102908:	75 0d                	jne    f0102917 <mem_init+0x107>
		panic("'pages' is a null pointer!");
f010290a:	51                   	push   %ecx
f010290b:	68 ce 5c 10 f0       	push   $0xf0105cce
f0102910:	68 b3 02 00 00       	push   $0x2b3
f0102915:	eb 34                	jmp    f010294b <mem_init+0x13b>

	// check number of free pages
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0102917:	a1 1c 4e 11 f0       	mov    0xf0114e1c,%eax
f010291c:	31 f6                	xor    %esi,%esi
f010291e:	eb 03                	jmp    f0102923 <mem_init+0x113>
f0102920:	8b 00                	mov    (%eax),%eax
		++nfree;
f0102922:	46                   	inc    %esi

	if (!pages)
		panic("'pages' is a null pointer!");

	// check number of free pages
	for (pp = page_free_list, nfree = 0; pp; pp = pp->pp_link)
f0102923:	85 c0                	test   %eax,%eax
f0102925:	75 f9                	jne    f0102920 <mem_init+0x110>
		++nfree;

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0102927:	83 ec 0c             	sub    $0xc,%esp
f010292a:	6a 00                	push   $0x0
f010292c:	e8 b4 fc ff ff       	call   f01025e5 <page_alloc>
f0102931:	89 44 24 18          	mov    %eax,0x18(%esp)
f0102935:	83 c4 10             	add    $0x10,%esp
f0102938:	85 c0                	test   %eax,%eax
f010293a:	75 19                	jne    f0102955 <mem_init+0x145>
f010293c:	68 e9 5c 10 f0       	push   $0xf0105ce9
f0102941:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102946:	68 bb 02 00 00       	push   $0x2bb
f010294b:	68 ce 5a 10 f0       	push   $0xf0105ace
f0102950:	e8 93 12 00 00       	call   f0103be8 <_panic>
	assert((pp1 = page_alloc(0)));
f0102955:	83 ec 0c             	sub    $0xc,%esp
f0102958:	6a 00                	push   $0x0
f010295a:	e8 86 fc ff ff       	call   f01025e5 <page_alloc>
f010295f:	83 c4 10             	add    $0x10,%esp
f0102962:	85 c0                	test   %eax,%eax
f0102964:	89 c7                	mov    %eax,%edi
f0102966:	75 11                	jne    f0102979 <mem_init+0x169>
f0102968:	68 ff 5c 10 f0       	push   $0xf0105cff
f010296d:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102972:	68 bc 02 00 00       	push   $0x2bc
f0102977:	eb d2                	jmp    f010294b <mem_init+0x13b>
	assert((pp2 = page_alloc(0)));
f0102979:	83 ec 0c             	sub    $0xc,%esp
f010297c:	6a 00                	push   $0x0
f010297e:	e8 62 fc ff ff       	call   f01025e5 <page_alloc>
f0102983:	83 c4 10             	add    $0x10,%esp
f0102986:	85 c0                	test   %eax,%eax
f0102988:	89 c3                	mov    %eax,%ebx
f010298a:	75 11                	jne    f010299d <mem_init+0x18d>
f010298c:	68 15 5d 10 f0       	push   $0xf0105d15
f0102991:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102996:	68 bd 02 00 00       	push   $0x2bd
f010299b:	eb ae                	jmp    f010294b <mem_init+0x13b>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f010299d:	3b 7c 24 08          	cmp    0x8(%esp),%edi
f01029a1:	75 11                	jne    f01029b4 <mem_init+0x1a4>
f01029a3:	68 2b 5d 10 f0       	push   $0xf0105d2b
f01029a8:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01029ad:	68 c0 02 00 00       	push   $0x2c0
f01029b2:	eb 97                	jmp    f010294b <mem_init+0x13b>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f01029b4:	39 f8                	cmp    %edi,%eax
f01029b6:	74 06                	je     f01029be <mem_init+0x1ae>
f01029b8:	3b 44 24 08          	cmp    0x8(%esp),%eax
f01029bc:	75 14                	jne    f01029d2 <mem_init+0x1c2>
f01029be:	68 3d 5d 10 f0       	push   $0xf0105d3d
f01029c3:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01029c8:	68 c1 02 00 00       	push   $0x2c1
f01029cd:	e9 79 ff ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(page2pa(pp0) < npages*PGSIZE);
f01029d2:	8b 44 24 08          	mov    0x8(%esp),%eax
f01029d6:	e8 0d f8 ff ff       	call   f01021e8 <page2pa>
f01029db:	8b 2d c4 76 11 f0    	mov    0xf01176c4,%ebp
f01029e1:	c1 e5 0c             	shl    $0xc,%ebp
f01029e4:	39 e8                	cmp    %ebp,%eax
f01029e6:	72 14                	jb     f01029fc <mem_init+0x1ec>
f01029e8:	68 5d 5d 10 f0       	push   $0xf0105d5d
f01029ed:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01029f2:	68 c2 02 00 00       	push   $0x2c2
f01029f7:	e9 4f ff ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(page2pa(pp1) < npages*PGSIZE);
f01029fc:	89 f8                	mov    %edi,%eax
f01029fe:	e8 e5 f7 ff ff       	call   f01021e8 <page2pa>
f0102a03:	39 e8                	cmp    %ebp,%eax
f0102a05:	72 14                	jb     f0102a1b <mem_init+0x20b>
f0102a07:	68 7a 5d 10 f0       	push   $0xf0105d7a
f0102a0c:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102a11:	68 c3 02 00 00       	push   $0x2c3
f0102a16:	e9 30 ff ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(page2pa(pp2) < npages*PGSIZE);
f0102a1b:	89 d8                	mov    %ebx,%eax
f0102a1d:	e8 c6 f7 ff ff       	call   f01021e8 <page2pa>
f0102a22:	39 e8                	cmp    %ebp,%eax
f0102a24:	72 14                	jb     f0102a3a <mem_init+0x22a>
f0102a26:	68 97 5d 10 f0       	push   $0xf0105d97
f0102a2b:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102a30:	68 c4 02 00 00       	push   $0x2c4
f0102a35:	e9 11 ff ff ff       	jmp    f010294b <mem_init+0x13b>
	// temporarily steal the rest of the free pages
	fl = page_free_list;
	page_free_list = 0;

	// should be no free memory
	assert(!page_alloc(0));
f0102a3a:	83 ec 0c             	sub    $0xc,%esp
	assert(page2pa(pp0) < npages*PGSIZE);
	assert(page2pa(pp1) < npages*PGSIZE);
	assert(page2pa(pp2) < npages*PGSIZE);

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0102a3d:	8b 2d 1c 4e 11 f0    	mov    0xf0114e1c,%ebp
	page_free_list = 0;

	// should be no free memory
	assert(!page_alloc(0));
f0102a43:	6a 00                	push   $0x0
	assert(page2pa(pp1) < npages*PGSIZE);
	assert(page2pa(pp2) < npages*PGSIZE);

	// temporarily steal the rest of the free pages
	fl = page_free_list;
	page_free_list = 0;
f0102a45:	c7 05 1c 4e 11 f0 00 	movl   $0x0,0xf0114e1c
f0102a4c:	00 00 00 

	// should be no free memory
	assert(!page_alloc(0));
f0102a4f:	e8 91 fb ff ff       	call   f01025e5 <page_alloc>
f0102a54:	83 c4 10             	add    $0x10,%esp
f0102a57:	85 c0                	test   %eax,%eax
f0102a59:	74 14                	je     f0102a6f <mem_init+0x25f>
f0102a5b:	68 b4 5d 10 f0       	push   $0xf0105db4
f0102a60:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102a65:	68 cb 02 00 00       	push   $0x2cb
f0102a6a:	e9 dc fe ff ff       	jmp    f010294b <mem_init+0x13b>

	// free and re-allocate?
	page_free(pp0);
f0102a6f:	83 ec 0c             	sub    $0xc,%esp
f0102a72:	ff 74 24 14          	pushl  0x14(%esp)
f0102a76:	e8 ab fb ff ff       	call   f0102626 <page_free>
	page_free(pp1);
f0102a7b:	89 3c 24             	mov    %edi,(%esp)
f0102a7e:	e8 a3 fb ff ff       	call   f0102626 <page_free>
	page_free(pp2);
f0102a83:	89 1c 24             	mov    %ebx,(%esp)
f0102a86:	e8 9b fb ff ff       	call   f0102626 <page_free>
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0102a8b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102a92:	e8 4e fb ff ff       	call   f01025e5 <page_alloc>
f0102a97:	83 c4 10             	add    $0x10,%esp
f0102a9a:	85 c0                	test   %eax,%eax
f0102a9c:	89 c3                	mov    %eax,%ebx
f0102a9e:	75 14                	jne    f0102ab4 <mem_init+0x2a4>
f0102aa0:	68 e9 5c 10 f0       	push   $0xf0105ce9
f0102aa5:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102aaa:	68 d2 02 00 00       	push   $0x2d2
f0102aaf:	e9 97 fe ff ff       	jmp    f010294b <mem_init+0x13b>
	assert((pp1 = page_alloc(0)));
f0102ab4:	83 ec 0c             	sub    $0xc,%esp
f0102ab7:	6a 00                	push   $0x0
f0102ab9:	e8 27 fb ff ff       	call   f01025e5 <page_alloc>
f0102abe:	89 44 24 18          	mov    %eax,0x18(%esp)
f0102ac2:	83 c4 10             	add    $0x10,%esp
f0102ac5:	85 c0                	test   %eax,%eax
f0102ac7:	75 14                	jne    f0102add <mem_init+0x2cd>
f0102ac9:	68 ff 5c 10 f0       	push   $0xf0105cff
f0102ace:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102ad3:	68 d3 02 00 00       	push   $0x2d3
f0102ad8:	e9 6e fe ff ff       	jmp    f010294b <mem_init+0x13b>
	assert((pp2 = page_alloc(0)));
f0102add:	83 ec 0c             	sub    $0xc,%esp
f0102ae0:	6a 00                	push   $0x0
f0102ae2:	e8 fe fa ff ff       	call   f01025e5 <page_alloc>
f0102ae7:	83 c4 10             	add    $0x10,%esp
f0102aea:	85 c0                	test   %eax,%eax
f0102aec:	89 c7                	mov    %eax,%edi
f0102aee:	75 14                	jne    f0102b04 <mem_init+0x2f4>
f0102af0:	68 15 5d 10 f0       	push   $0xf0105d15
f0102af5:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102afa:	68 d4 02 00 00       	push   $0x2d4
f0102aff:	e9 47 fe ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0102b04:	39 5c 24 08          	cmp    %ebx,0x8(%esp)
f0102b08:	75 14                	jne    f0102b1e <mem_init+0x30e>
f0102b0a:	68 2b 5d 10 f0       	push   $0xf0105d2b
f0102b0f:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102b14:	68 d6 02 00 00       	push   $0x2d6
f0102b19:	e9 2d fe ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0102b1e:	3b 44 24 08          	cmp    0x8(%esp),%eax
f0102b22:	74 04                	je     f0102b28 <mem_init+0x318>
f0102b24:	39 d8                	cmp    %ebx,%eax
f0102b26:	75 14                	jne    f0102b3c <mem_init+0x32c>
f0102b28:	68 3d 5d 10 f0       	push   $0xf0105d3d
f0102b2d:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102b32:	68 d7 02 00 00       	push   $0x2d7
f0102b37:	e9 0f fe ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(!page_alloc(0));
f0102b3c:	83 ec 0c             	sub    $0xc,%esp
f0102b3f:	6a 00                	push   $0x0
f0102b41:	e8 9f fa ff ff       	call   f01025e5 <page_alloc>
f0102b46:	83 c4 10             	add    $0x10,%esp
f0102b49:	85 c0                	test   %eax,%eax
f0102b4b:	74 14                	je     f0102b61 <mem_init+0x351>
f0102b4d:	68 b4 5d 10 f0       	push   $0xf0105db4
f0102b52:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102b57:	68 d8 02 00 00       	push   $0x2d8
f0102b5c:	e9 ea fd ff ff       	jmp    f010294b <mem_init+0x13b>

	// test flags
	memset(page2kva(pp0), 1, PGSIZE);
f0102b61:	89 d8                	mov    %ebx,%eax
f0102b63:	e8 f1 f6 ff ff       	call   f0102259 <page2kva>
f0102b68:	52                   	push   %edx
f0102b69:	68 00 10 00 00       	push   $0x1000
f0102b6e:	6a 01                	push   $0x1
f0102b70:	50                   	push   %eax
f0102b71:	e8 59 d6 ff ff       	call   f01001cf <memset>
	page_free(pp0);
f0102b76:	89 1c 24             	mov    %ebx,(%esp)
f0102b79:	e8 a8 fa ff ff       	call   f0102626 <page_free>
	assert((pp = page_alloc(ALLOC_ZERO)));
f0102b7e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
f0102b85:	e8 5b fa ff ff       	call   f01025e5 <page_alloc>
f0102b8a:	83 c4 10             	add    $0x10,%esp
f0102b8d:	85 c0                	test   %eax,%eax
f0102b8f:	75 14                	jne    f0102ba5 <mem_init+0x395>
f0102b91:	68 c3 5d 10 f0       	push   $0xf0105dc3
f0102b96:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102b9b:	68 dd 02 00 00       	push   $0x2dd
f0102ba0:	e9 a6 fd ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(pp && pp0 == pp);
f0102ba5:	39 c3                	cmp    %eax,%ebx
f0102ba7:	74 14                	je     f0102bbd <mem_init+0x3ad>
f0102ba9:	68 e1 5d 10 f0       	push   $0xf0105de1
f0102bae:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102bb3:	68 de 02 00 00       	push   $0x2de
f0102bb8:	e9 8e fd ff ff       	jmp    f010294b <mem_init+0x13b>
	c = page2kva(pp);
f0102bbd:	89 d8                	mov    %ebx,%eax
f0102bbf:	e8 95 f6 ff ff       	call   f0102259 <page2kva>
	for (i = 0; i < PGSIZE; i++)
f0102bc4:	31 d2                	xor    %edx,%edx
		assert(c[i] == 0);
f0102bc6:	80 3c 10 00          	cmpb   $0x0,(%eax,%edx,1)
f0102bca:	74 14                	je     f0102be0 <mem_init+0x3d0>
f0102bcc:	68 f1 5d 10 f0       	push   $0xf0105df1
f0102bd1:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102bd6:	68 e1 02 00 00       	push   $0x2e1
f0102bdb:	e9 6b fd ff ff       	jmp    f010294b <mem_init+0x13b>
	memset(page2kva(pp0), 1, PGSIZE);
	page_free(pp0);
	assert((pp = page_alloc(ALLOC_ZERO)));
	assert(pp && pp0 == pp);
	c = page2kva(pp);
	for (i = 0; i < PGSIZE; i++)
f0102be0:	42                   	inc    %edx
f0102be1:	81 fa 00 10 00 00    	cmp    $0x1000,%edx
f0102be7:	75 dd                	jne    f0102bc6 <mem_init+0x3b6>

	// give free list back
	page_free_list = fl;

	// free the pages we took
	page_free(pp0);
f0102be9:	83 ec 0c             	sub    $0xc,%esp
f0102bec:	53                   	push   %ebx
	c = page2kva(pp);
	for (i = 0; i < PGSIZE; i++)
		assert(c[i] == 0);

	// give free list back
	page_free_list = fl;
f0102bed:	89 2d 1c 4e 11 f0    	mov    %ebp,0xf0114e1c

	// free the pages we took
	page_free(pp0);
f0102bf3:	e8 2e fa ff ff       	call   f0102626 <page_free>
	page_free(pp1);
f0102bf8:	5b                   	pop    %ebx
f0102bf9:	ff 74 24 14          	pushl  0x14(%esp)
f0102bfd:	e8 24 fa ff ff       	call   f0102626 <page_free>
	page_free(pp2);
f0102c02:	89 3c 24             	mov    %edi,(%esp)
f0102c05:	e8 1c fa ff ff       	call   f0102626 <page_free>

	// number of free pages should be the same
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0102c0a:	a1 1c 4e 11 f0       	mov    0xf0114e1c,%eax
f0102c0f:	83 c4 10             	add    $0x10,%esp
f0102c12:	eb 03                	jmp    f0102c17 <mem_init+0x407>
f0102c14:	8b 00                	mov    (%eax),%eax
		--nfree;
f0102c16:	4e                   	dec    %esi
	page_free(pp0);
	page_free(pp1);
	page_free(pp2);

	// number of free pages should be the same
	for (pp = page_free_list; pp; pp = pp->pp_link)
f0102c17:	85 c0                	test   %eax,%eax
f0102c19:	75 f9                	jne    f0102c14 <mem_init+0x404>
		--nfree;
	assert(nfree == 0);
f0102c1b:	85 f6                	test   %esi,%esi
f0102c1d:	74 14                	je     f0102c33 <mem_init+0x423>
f0102c1f:	68 fb 5d 10 f0       	push   $0xf0105dfb
f0102c24:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102c29:	68 ee 02 00 00       	push   $0x2ee
f0102c2e:	e9 18 fd ff ff       	jmp    f010294b <mem_init+0x13b>

	printk("check_page_alloc() succeeded!\n");
f0102c33:	83 ec 0c             	sub    $0xc,%esp
f0102c36:	68 06 5e 10 f0       	push   $0xf0105e06
f0102c3b:	e8 90 f5 ff ff       	call   f01021d0 <printk>
	void *va;
	int i;

	// should be able to allocate three pages
	pp0 = pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0102c40:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0102c47:	e8 99 f9 ff ff       	call   f01025e5 <page_alloc>
f0102c4c:	83 c4 10             	add    $0x10,%esp
f0102c4f:	85 c0                	test   %eax,%eax
f0102c51:	89 c6                	mov    %eax,%esi
f0102c53:	75 14                	jne    f0102c69 <mem_init+0x459>
f0102c55:	68 e9 5c 10 f0       	push   $0xf0105ce9
f0102c5a:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102c5f:	68 4a 03 00 00       	push   $0x34a
f0102c64:	e9 e2 fc ff ff       	jmp    f010294b <mem_init+0x13b>
	assert((pp1 = page_alloc(0)));
f0102c69:	83 ec 0c             	sub    $0xc,%esp
f0102c6c:	6a 00                	push   $0x0
f0102c6e:	e8 72 f9 ff ff       	call   f01025e5 <page_alloc>
f0102c73:	83 c4 10             	add    $0x10,%esp
f0102c76:	85 c0                	test   %eax,%eax
f0102c78:	89 c3                	mov    %eax,%ebx
f0102c7a:	75 14                	jne    f0102c90 <mem_init+0x480>
f0102c7c:	68 ff 5c 10 f0       	push   $0xf0105cff
f0102c81:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102c86:	68 4b 03 00 00       	push   $0x34b
f0102c8b:	e9 bb fc ff ff       	jmp    f010294b <mem_init+0x13b>
	assert((pp2 = page_alloc(0)));
f0102c90:	83 ec 0c             	sub    $0xc,%esp
f0102c93:	6a 00                	push   $0x0
f0102c95:	e8 4b f9 ff ff       	call   f01025e5 <page_alloc>
f0102c9a:	83 c4 10             	add    $0x10,%esp
f0102c9d:	85 c0                	test   %eax,%eax
f0102c9f:	89 c7                	mov    %eax,%edi
f0102ca1:	75 14                	jne    f0102cb7 <mem_init+0x4a7>
f0102ca3:	68 15 5d 10 f0       	push   $0xf0105d15
f0102ca8:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102cad:	68 4c 03 00 00       	push   $0x34c
f0102cb2:	e9 94 fc ff ff       	jmp    f010294b <mem_init+0x13b>

	assert(pp0);
	assert(pp1 && pp1 != pp0);
f0102cb7:	39 f3                	cmp    %esi,%ebx
f0102cb9:	75 14                	jne    f0102ccf <mem_init+0x4bf>
f0102cbb:	68 2b 5d 10 f0       	push   $0xf0105d2b
f0102cc0:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102cc5:	68 4f 03 00 00       	push   $0x34f
f0102cca:	e9 7c fc ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(pp2 && pp2 != pp1 && pp2 != pp0);
f0102ccf:	39 d8                	cmp    %ebx,%eax
f0102cd1:	74 04                	je     f0102cd7 <mem_init+0x4c7>
f0102cd3:	39 f0                	cmp    %esi,%eax
f0102cd5:	75 14                	jne    f0102ceb <mem_init+0x4db>
f0102cd7:	68 3d 5d 10 f0       	push   $0xf0105d3d
f0102cdc:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102ce1:	68 50 03 00 00       	push   $0x350
f0102ce6:	e9 60 fc ff ff       	jmp    f010294b <mem_init+0x13b>

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0102ceb:	a1 1c 4e 11 f0       	mov    0xf0114e1c,%eax
	page_free_list = 0;
f0102cf0:	c7 05 1c 4e 11 f0 00 	movl   $0x0,0xf0114e1c
f0102cf7:	00 00 00 
	assert(pp0);
	assert(pp1 && pp1 != pp0);
	assert(pp2 && pp2 != pp1 && pp2 != pp0);

	// temporarily steal the rest of the free pages
	fl = page_free_list;
f0102cfa:	89 44 24 08          	mov    %eax,0x8(%esp)
	page_free_list = 0;

	// should be no free memory
	assert(!page_alloc(0));
f0102cfe:	83 ec 0c             	sub    $0xc,%esp
f0102d01:	6a 00                	push   $0x0
f0102d03:	e8 dd f8 ff ff       	call   f01025e5 <page_alloc>
f0102d08:	83 c4 10             	add    $0x10,%esp
f0102d0b:	85 c0                	test   %eax,%eax
f0102d0d:	74 14                	je     f0102d23 <mem_init+0x513>
f0102d0f:	68 b4 5d 10 f0       	push   $0xf0105db4
f0102d14:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102d19:	68 57 03 00 00       	push   $0x357
f0102d1e:	e9 28 fc ff ff       	jmp    f010294b <mem_init+0x13b>

	// there is no page allocated at address 0
	assert(page_lookup(kern_pgdir, (void *) 0x0, &ptep) == NULL);
f0102d23:	51                   	push   %ecx
f0102d24:	8d 44 24 20          	lea    0x20(%esp),%eax
f0102d28:	50                   	push   %eax
f0102d29:	6a 00                	push   $0x0
f0102d2b:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f0102d31:	e8 01 fa ff ff       	call   f0102737 <page_lookup>
f0102d36:	83 c4 10             	add    $0x10,%esp
f0102d39:	85 c0                	test   %eax,%eax
f0102d3b:	74 14                	je     f0102d51 <mem_init+0x541>
f0102d3d:	68 25 5e 10 f0       	push   $0xf0105e25
f0102d42:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102d47:	68 5a 03 00 00       	push   $0x35a
f0102d4c:	e9 fa fb ff ff       	jmp    f010294b <mem_init+0x13b>

	// there is no free memory, so we can't allocate a page table
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) < 0);
f0102d51:	6a 02                	push   $0x2
f0102d53:	6a 00                	push   $0x0
f0102d55:	53                   	push   %ebx
f0102d56:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f0102d5c:	e8 54 fa ff ff       	call   f01027b5 <page_insert>
f0102d61:	83 c4 10             	add    $0x10,%esp
f0102d64:	85 c0                	test   %eax,%eax
f0102d66:	78 14                	js     f0102d7c <mem_init+0x56c>
f0102d68:	68 5a 5e 10 f0       	push   $0xf0105e5a
f0102d6d:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102d72:	68 5d 03 00 00       	push   $0x35d
f0102d77:	e9 cf fb ff ff       	jmp    f010294b <mem_init+0x13b>

	// free pp0 and try again: pp0 should be used for page table
	page_free(pp0);
f0102d7c:	83 ec 0c             	sub    $0xc,%esp
f0102d7f:	56                   	push   %esi
f0102d80:	e8 a1 f8 ff ff       	call   f0102626 <page_free>
	assert(page_insert(kern_pgdir, pp1, 0x0, PTE_W) == 0);
f0102d85:	6a 02                	push   $0x2
f0102d87:	6a 00                	push   $0x0
f0102d89:	53                   	push   %ebx
f0102d8a:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f0102d90:	e8 20 fa ff ff       	call   f01027b5 <page_insert>
f0102d95:	83 c4 20             	add    $0x20,%esp
f0102d98:	85 c0                	test   %eax,%eax
f0102d9a:	74 14                	je     f0102db0 <mem_init+0x5a0>
f0102d9c:	68 87 5e 10 f0       	push   $0xf0105e87
f0102da1:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102da6:	68 61 03 00 00       	push   $0x361
f0102dab:	e9 9b fb ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f0102db0:	8b 2d c8 76 11 f0    	mov    0xf01176c8,%ebp
f0102db6:	89 f0                	mov    %esi,%eax
f0102db8:	e8 2b f4 ff ff       	call   f01021e8 <page2pa>
f0102dbd:	8b 55 00             	mov    0x0(%ebp),%edx
f0102dc0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f0102dc6:	39 c2                	cmp    %eax,%edx
f0102dc8:	74 14                	je     f0102dde <mem_init+0x5ce>
f0102dca:	68 b5 5e 10 f0       	push   $0xf0105eb5
f0102dcf:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102dd4:	68 62 03 00 00       	push   $0x362
f0102dd9:	e9 6d fb ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(check_va2pa(kern_pgdir, 0x0) == page2pa(pp1));
f0102dde:	31 d2                	xor    %edx,%edx
f0102de0:	89 e8                	mov    %ebp,%eax
f0102de2:	e8 8b f4 ff ff       	call   f0102272 <check_va2pa>
f0102de7:	89 c5                	mov    %eax,%ebp
f0102de9:	89 d8                	mov    %ebx,%eax
f0102deb:	e8 f8 f3 ff ff       	call   f01021e8 <page2pa>
f0102df0:	39 c5                	cmp    %eax,%ebp
f0102df2:	74 14                	je     f0102e08 <mem_init+0x5f8>
f0102df4:	68 dd 5e 10 f0       	push   $0xf0105edd
f0102df9:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102dfe:	68 63 03 00 00       	push   $0x363
f0102e03:	e9 43 fb ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(pp1->pp_ref == 1);
f0102e08:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f0102e0d:	74 14                	je     f0102e23 <mem_init+0x613>
f0102e0f:	68 0a 5f 10 f0       	push   $0xf0105f0a
f0102e14:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102e19:	68 64 03 00 00       	push   $0x364
f0102e1e:	e9 28 fb ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(pp0->pp_ref == 1);
f0102e23:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f0102e28:	74 14                	je     f0102e3e <mem_init+0x62e>
f0102e2a:	68 1b 5f 10 f0       	push   $0xf0105f1b
f0102e2f:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102e34:	68 65 03 00 00       	push   $0x365
f0102e39:	e9 0d fb ff ff       	jmp    f010294b <mem_init+0x13b>

	// should be able to map pp2 at PGSIZE because pp0 is already allocated for page table
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102e3e:	6a 02                	push   $0x2
f0102e40:	68 00 10 00 00       	push   $0x1000
f0102e45:	57                   	push   %edi
f0102e46:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f0102e4c:	e8 64 f9 ff ff       	call   f01027b5 <page_insert>
f0102e51:	83 c4 10             	add    $0x10,%esp
f0102e54:	85 c0                	test   %eax,%eax
f0102e56:	74 14                	je     f0102e6c <mem_init+0x65c>
f0102e58:	68 2c 5f 10 f0       	push   $0xf0105f2c
f0102e5d:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102e62:	68 68 03 00 00       	push   $0x368
f0102e67:	e9 df fa ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102e6c:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f0102e71:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102e76:	e8 f7 f3 ff ff       	call   f0102272 <check_va2pa>
f0102e7b:	89 c5                	mov    %eax,%ebp
f0102e7d:	89 f8                	mov    %edi,%eax
f0102e7f:	e8 64 f3 ff ff       	call   f01021e8 <page2pa>
f0102e84:	39 c5                	cmp    %eax,%ebp
f0102e86:	74 14                	je     f0102e9c <mem_init+0x68c>
f0102e88:	68 65 5f 10 f0       	push   $0xf0105f65
f0102e8d:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102e92:	68 69 03 00 00       	push   $0x369
f0102e97:	e9 af fa ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(pp2->pp_ref == 1);
f0102e9c:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0102ea1:	74 14                	je     f0102eb7 <mem_init+0x6a7>
f0102ea3:	68 95 5f 10 f0       	push   $0xf0105f95
f0102ea8:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102ead:	68 6a 03 00 00       	push   $0x36a
f0102eb2:	e9 94 fa ff ff       	jmp    f010294b <mem_init+0x13b>

	// should be no free memory
	assert(!page_alloc(0));
f0102eb7:	83 ec 0c             	sub    $0xc,%esp
f0102eba:	6a 00                	push   $0x0
f0102ebc:	e8 24 f7 ff ff       	call   f01025e5 <page_alloc>
f0102ec1:	83 c4 10             	add    $0x10,%esp
f0102ec4:	85 c0                	test   %eax,%eax
f0102ec6:	74 14                	je     f0102edc <mem_init+0x6cc>
f0102ec8:	68 b4 5d 10 f0       	push   $0xf0105db4
f0102ecd:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102ed2:	68 6d 03 00 00       	push   $0x36d
f0102ed7:	e9 6f fa ff ff       	jmp    f010294b <mem_init+0x13b>

	// should be able to map pp2 at PGSIZE because it's already there
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0102edc:	6a 02                	push   $0x2
f0102ede:	68 00 10 00 00       	push   $0x1000
f0102ee3:	57                   	push   %edi
f0102ee4:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f0102eea:	e8 c6 f8 ff ff       	call   f01027b5 <page_insert>
f0102eef:	83 c4 10             	add    $0x10,%esp
f0102ef2:	85 c0                	test   %eax,%eax
f0102ef4:	74 14                	je     f0102f0a <mem_init+0x6fa>
f0102ef6:	68 2c 5f 10 f0       	push   $0xf0105f2c
f0102efb:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102f00:	68 70 03 00 00       	push   $0x370
f0102f05:	e9 41 fa ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102f0a:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f0102f0f:	ba 00 10 00 00       	mov    $0x1000,%edx
f0102f14:	e8 59 f3 ff ff       	call   f0102272 <check_va2pa>
f0102f19:	89 c5                	mov    %eax,%ebp
f0102f1b:	89 f8                	mov    %edi,%eax
f0102f1d:	e8 c6 f2 ff ff       	call   f01021e8 <page2pa>
f0102f22:	39 c5                	cmp    %eax,%ebp
f0102f24:	74 14                	je     f0102f3a <mem_init+0x72a>
f0102f26:	68 65 5f 10 f0       	push   $0xf0105f65
f0102f2b:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102f30:	68 71 03 00 00       	push   $0x371
f0102f35:	e9 11 fa ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(pp2->pp_ref == 1);
f0102f3a:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0102f3f:	74 14                	je     f0102f55 <mem_init+0x745>
f0102f41:	68 95 5f 10 f0       	push   $0xf0105f95
f0102f46:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102f4b:	68 72 03 00 00       	push   $0x372
f0102f50:	e9 f6 f9 ff ff       	jmp    f010294b <mem_init+0x13b>

	// pp2 should NOT be on the free list
	// could happen in ref counts are handled sloppily in page_insert
	assert(!page_alloc(0));
f0102f55:	83 ec 0c             	sub    $0xc,%esp
f0102f58:	6a 00                	push   $0x0
f0102f5a:	e8 86 f6 ff ff       	call   f01025e5 <page_alloc>
f0102f5f:	83 c4 10             	add    $0x10,%esp
f0102f62:	85 c0                	test   %eax,%eax
f0102f64:	74 14                	je     f0102f7a <mem_init+0x76a>
f0102f66:	68 b4 5d 10 f0       	push   $0xf0105db4
f0102f6b:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102f70:	68 76 03 00 00       	push   $0x376
f0102f75:	e9 d1 f9 ff ff       	jmp    f010294b <mem_init+0x13b>

	// check that pgdir_walk returns a pointer to the pte
	ptep = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(PGSIZE)]));
f0102f7a:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f0102f7f:	ba 79 03 00 00       	mov    $0x379,%edx
f0102f84:	8b 08                	mov    (%eax),%ecx
f0102f86:	b8 ce 5a 10 f0       	mov    $0xf0105ace,%eax
f0102f8b:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0102f91:	e8 9a f2 ff ff       	call   f0102230 <_kaddr>
f0102f96:	89 44 24 1c          	mov    %eax,0x1c(%esp)
	assert(pgdir_walk(kern_pgdir, (void*)PGSIZE, 0) == ptep+PTX(PGSIZE));
f0102f9a:	52                   	push   %edx
f0102f9b:	6a 00                	push   $0x0
f0102f9d:	68 00 10 00 00       	push   $0x1000
f0102fa2:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f0102fa8:	e8 d2 f6 ff ff       	call   f010267f <pgdir_walk>
f0102fad:	8b 54 24 2c          	mov    0x2c(%esp),%edx
f0102fb1:	83 c4 10             	add    $0x10,%esp
f0102fb4:	83 c2 04             	add    $0x4,%edx
f0102fb7:	39 d0                	cmp    %edx,%eax
f0102fb9:	74 14                	je     f0102fcf <mem_init+0x7bf>
f0102fbb:	68 a6 5f 10 f0       	push   $0xf0105fa6
f0102fc0:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102fc5:	68 7a 03 00 00       	push   $0x37a
f0102fca:	e9 7c f9 ff ff       	jmp    f010294b <mem_init+0x13b>

	// should be able to change permissions too.
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W|PTE_U) == 0);
f0102fcf:	6a 06                	push   $0x6
f0102fd1:	68 00 10 00 00       	push   $0x1000
f0102fd6:	57                   	push   %edi
f0102fd7:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f0102fdd:	e8 d3 f7 ff ff       	call   f01027b5 <page_insert>
f0102fe2:	83 c4 10             	add    $0x10,%esp
f0102fe5:	85 c0                	test   %eax,%eax
f0102fe7:	74 14                	je     f0102ffd <mem_init+0x7ed>
f0102fe9:	68 e3 5f 10 f0       	push   $0xf0105fe3
f0102fee:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0102ff3:	68 7d 03 00 00       	push   $0x37d
f0102ff8:	e9 4e f9 ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp2));
f0102ffd:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f0103002:	ba 00 10 00 00       	mov    $0x1000,%edx
f0103007:	e8 66 f2 ff ff       	call   f0102272 <check_va2pa>
f010300c:	89 c5                	mov    %eax,%ebp
f010300e:	89 f8                	mov    %edi,%eax
f0103010:	e8 d3 f1 ff ff       	call   f01021e8 <page2pa>
f0103015:	39 c5                	cmp    %eax,%ebp
f0103017:	74 14                	je     f010302d <mem_init+0x81d>
f0103019:	68 65 5f 10 f0       	push   $0xf0105f65
f010301e:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103023:	68 7e 03 00 00       	push   $0x37e
f0103028:	e9 1e f9 ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(pp2->pp_ref == 1);
f010302d:	66 83 7f 04 01       	cmpw   $0x1,0x4(%edi)
f0103032:	74 14                	je     f0103048 <mem_init+0x838>
f0103034:	68 95 5f 10 f0       	push   $0xf0105f95
f0103039:	68 2a 5b 10 f0       	push   $0xf0105b2a
f010303e:	68 7f 03 00 00       	push   $0x37f
f0103043:	e9 03 f9 ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U);
f0103048:	50                   	push   %eax
f0103049:	6a 00                	push   $0x0
f010304b:	68 00 10 00 00       	push   $0x1000
f0103050:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f0103056:	e8 24 f6 ff ff       	call   f010267f <pgdir_walk>
f010305b:	83 c4 10             	add    $0x10,%esp
f010305e:	f6 00 04             	testb  $0x4,(%eax)
f0103061:	75 14                	jne    f0103077 <mem_init+0x867>
f0103063:	68 22 60 10 f0       	push   $0xf0106022
f0103068:	68 2a 5b 10 f0       	push   $0xf0105b2a
f010306d:	68 80 03 00 00       	push   $0x380
f0103072:	e9 d4 f8 ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(kern_pgdir[0] & PTE_U);
f0103077:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f010307c:	f6 00 04             	testb  $0x4,(%eax)
f010307f:	75 14                	jne    f0103095 <mem_init+0x885>
f0103081:	68 55 60 10 f0       	push   $0xf0106055
f0103086:	68 2a 5b 10 f0       	push   $0xf0105b2a
f010308b:	68 81 03 00 00       	push   $0x381
f0103090:	e9 b6 f8 ff ff       	jmp    f010294b <mem_init+0x13b>

	// should be able to remap with fewer permissions
	assert(page_insert(kern_pgdir, pp2, (void*) PGSIZE, PTE_W) == 0);
f0103095:	6a 02                	push   $0x2
f0103097:	68 00 10 00 00       	push   $0x1000
f010309c:	57                   	push   %edi
f010309d:	50                   	push   %eax
f010309e:	e8 12 f7 ff ff       	call   f01027b5 <page_insert>
f01030a3:	83 c4 10             	add    $0x10,%esp
f01030a6:	85 c0                	test   %eax,%eax
f01030a8:	74 14                	je     f01030be <mem_init+0x8ae>
f01030aa:	68 2c 5f 10 f0       	push   $0xf0105f2c
f01030af:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01030b4:	68 84 03 00 00       	push   $0x384
f01030b9:	e9 8d f8 ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_W);
f01030be:	55                   	push   %ebp
f01030bf:	6a 00                	push   $0x0
f01030c1:	68 00 10 00 00       	push   $0x1000
f01030c6:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f01030cc:	e8 ae f5 ff ff       	call   f010267f <pgdir_walk>
f01030d1:	83 c4 10             	add    $0x10,%esp
f01030d4:	f6 00 02             	testb  $0x2,(%eax)
f01030d7:	75 14                	jne    f01030ed <mem_init+0x8dd>
f01030d9:	68 6b 60 10 f0       	push   $0xf010606b
f01030de:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01030e3:	68 85 03 00 00       	push   $0x385
f01030e8:	e9 5e f8 ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f01030ed:	51                   	push   %ecx
f01030ee:	6a 00                	push   $0x0
f01030f0:	68 00 10 00 00       	push   $0x1000
f01030f5:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f01030fb:	e8 7f f5 ff ff       	call   f010267f <pgdir_walk>
f0103100:	83 c4 10             	add    $0x10,%esp
f0103103:	f6 00 04             	testb  $0x4,(%eax)
f0103106:	74 14                	je     f010311c <mem_init+0x90c>
f0103108:	68 9e 60 10 f0       	push   $0xf010609e
f010310d:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103112:	68 86 03 00 00       	push   $0x386
f0103117:	e9 2f f8 ff ff       	jmp    f010294b <mem_init+0x13b>

	// should not be able to map at PTSIZE because need free page for page table
	assert(page_insert(kern_pgdir, pp0, (void*) PTSIZE, PTE_W) < 0);
f010311c:	6a 02                	push   $0x2
f010311e:	68 00 00 40 00       	push   $0x400000
f0103123:	56                   	push   %esi
f0103124:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f010312a:	e8 86 f6 ff ff       	call   f01027b5 <page_insert>
f010312f:	83 c4 10             	add    $0x10,%esp
f0103132:	85 c0                	test   %eax,%eax
f0103134:	78 14                	js     f010314a <mem_init+0x93a>
f0103136:	68 d4 60 10 f0       	push   $0xf01060d4
f010313b:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103140:	68 89 03 00 00       	push   $0x389
f0103145:	e9 01 f8 ff ff       	jmp    f010294b <mem_init+0x13b>

	// insert pp1 at PGSIZE (replacing pp2)
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, PTE_W) == 0);
f010314a:	6a 02                	push   $0x2
f010314c:	68 00 10 00 00       	push   $0x1000
f0103151:	53                   	push   %ebx
f0103152:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f0103158:	e8 58 f6 ff ff       	call   f01027b5 <page_insert>
f010315d:	83 c4 10             	add    $0x10,%esp
f0103160:	85 c0                	test   %eax,%eax
f0103162:	74 14                	je     f0103178 <mem_init+0x968>
f0103164:	68 0c 61 10 f0       	push   $0xf010610c
f0103169:	68 2a 5b 10 f0       	push   $0xf0105b2a
f010316e:	68 8c 03 00 00       	push   $0x38c
f0103173:	e9 d3 f7 ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(!(*pgdir_walk(kern_pgdir, (void*) PGSIZE, 0) & PTE_U));
f0103178:	52                   	push   %edx
f0103179:	6a 00                	push   $0x0
f010317b:	68 00 10 00 00       	push   $0x1000
f0103180:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f0103186:	e8 f4 f4 ff ff       	call   f010267f <pgdir_walk>
f010318b:	83 c4 10             	add    $0x10,%esp
f010318e:	f6 00 04             	testb  $0x4,(%eax)
f0103191:	74 14                	je     f01031a7 <mem_init+0x997>
f0103193:	68 9e 60 10 f0       	push   $0xf010609e
f0103198:	68 2a 5b 10 f0       	push   $0xf0105b2a
f010319d:	68 8d 03 00 00       	push   $0x38d
f01031a2:	e9 a4 f7 ff ff       	jmp    f010294b <mem_init+0x13b>

	// should have pp1 at both 0 and PGSIZE, pp2 nowhere, ...
	assert(check_va2pa(kern_pgdir, 0) == page2pa(pp1));
f01031a7:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f01031ac:	31 d2                	xor    %edx,%edx
f01031ae:	e8 bf f0 ff ff       	call   f0102272 <check_va2pa>
f01031b3:	89 c5                	mov    %eax,%ebp
f01031b5:	89 d8                	mov    %ebx,%eax
f01031b7:	e8 2c f0 ff ff       	call   f01021e8 <page2pa>
f01031bc:	39 c5                	cmp    %eax,%ebp
f01031be:	74 14                	je     f01031d4 <mem_init+0x9c4>
f01031c0:	68 45 61 10 f0       	push   $0xf0106145
f01031c5:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01031ca:	68 90 03 00 00       	push   $0x390
f01031cf:	e9 77 f7 ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f01031d4:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f01031d9:	ba 00 10 00 00       	mov    $0x1000,%edx
f01031de:	e8 8f f0 ff ff       	call   f0102272 <check_va2pa>
f01031e3:	89 c5                	mov    %eax,%ebp
f01031e5:	89 d8                	mov    %ebx,%eax
f01031e7:	e8 fc ef ff ff       	call   f01021e8 <page2pa>
f01031ec:	39 c5                	cmp    %eax,%ebp
f01031ee:	74 14                	je     f0103204 <mem_init+0x9f4>
f01031f0:	68 70 61 10 f0       	push   $0xf0106170
f01031f5:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01031fa:	68 91 03 00 00       	push   $0x391
f01031ff:	e9 47 f7 ff ff       	jmp    f010294b <mem_init+0x13b>
	// ... and ref counts should reflect this
	assert(pp1->pp_ref == 2);
f0103204:	66 83 7b 04 02       	cmpw   $0x2,0x4(%ebx)
f0103209:	74 14                	je     f010321f <mem_init+0xa0f>
f010320b:	68 a0 61 10 f0       	push   $0xf01061a0
f0103210:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103215:	68 93 03 00 00       	push   $0x393
f010321a:	e9 2c f7 ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(pp2->pp_ref == 0);
f010321f:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f0103224:	74 14                	je     f010323a <mem_init+0xa2a>
f0103226:	68 b1 61 10 f0       	push   $0xf01061b1
f010322b:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103230:	68 94 03 00 00       	push   $0x394
f0103235:	e9 11 f7 ff ff       	jmp    f010294b <mem_init+0x13b>

	// pp2 should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp2);
f010323a:	83 ec 0c             	sub    $0xc,%esp
f010323d:	6a 00                	push   $0x0
f010323f:	e8 a1 f3 ff ff       	call   f01025e5 <page_alloc>
f0103244:	83 c4 10             	add    $0x10,%esp
f0103247:	85 c0                	test   %eax,%eax
f0103249:	89 c5                	mov    %eax,%ebp
f010324b:	74 04                	je     f0103251 <mem_init+0xa41>
f010324d:	39 f8                	cmp    %edi,%eax
f010324f:	74 14                	je     f0103265 <mem_init+0xa55>
f0103251:	68 c2 61 10 f0       	push   $0xf01061c2
f0103256:	68 2a 5b 10 f0       	push   $0xf0105b2a
f010325b:	68 97 03 00 00       	push   $0x397
f0103260:	e9 e6 f6 ff ff       	jmp    f010294b <mem_init+0x13b>

	// unmapping pp1 at 0 should keep pp1 at PGSIZE
	page_remove(kern_pgdir, 0x0);
f0103265:	50                   	push   %eax
f0103266:	50                   	push   %eax
f0103267:	6a 00                	push   $0x0
f0103269:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f010326f:	e8 05 f5 ff ff       	call   f0102779 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0103274:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f0103279:	31 d2                	xor    %edx,%edx
f010327b:	e8 f2 ef ff ff       	call   f0102272 <check_va2pa>
f0103280:	83 c4 10             	add    $0x10,%esp
f0103283:	40                   	inc    %eax
f0103284:	74 14                	je     f010329a <mem_init+0xa8a>
f0103286:	68 e4 61 10 f0       	push   $0xf01061e4
f010328b:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103290:	68 9b 03 00 00       	push   $0x39b
f0103295:	e9 b1 f6 ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(check_va2pa(kern_pgdir, PGSIZE) == page2pa(pp1));
f010329a:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f010329f:	ba 00 10 00 00       	mov    $0x1000,%edx
f01032a4:	e8 c9 ef ff ff       	call   f0102272 <check_va2pa>
f01032a9:	89 44 24 0c          	mov    %eax,0xc(%esp)
f01032ad:	89 d8                	mov    %ebx,%eax
f01032af:	e8 34 ef ff ff       	call   f01021e8 <page2pa>
f01032b4:	39 44 24 0c          	cmp    %eax,0xc(%esp)
f01032b8:	74 14                	je     f01032ce <mem_init+0xabe>
f01032ba:	68 70 61 10 f0       	push   $0xf0106170
f01032bf:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01032c4:	68 9c 03 00 00       	push   $0x39c
f01032c9:	e9 7d f6 ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(pp1->pp_ref == 1);
f01032ce:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f01032d3:	74 14                	je     f01032e9 <mem_init+0xad9>
f01032d5:	68 0a 5f 10 f0       	push   $0xf0105f0a
f01032da:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01032df:	68 9d 03 00 00       	push   $0x39d
f01032e4:	e9 62 f6 ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(pp2->pp_ref == 0);
f01032e9:	66 83 7f 04 00       	cmpw   $0x0,0x4(%edi)
f01032ee:	74 14                	je     f0103304 <mem_init+0xaf4>
f01032f0:	68 b1 61 10 f0       	push   $0xf01061b1
f01032f5:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01032fa:	68 9e 03 00 00       	push   $0x39e
f01032ff:	e9 47 f6 ff ff       	jmp    f010294b <mem_init+0x13b>

	// test re-inserting pp1 at PGSIZE
	assert(page_insert(kern_pgdir, pp1, (void*) PGSIZE, 0) == 0);
f0103304:	6a 00                	push   $0x0
f0103306:	68 00 10 00 00       	push   $0x1000
f010330b:	53                   	push   %ebx
f010330c:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f0103312:	e8 9e f4 ff ff       	call   f01027b5 <page_insert>
f0103317:	83 c4 10             	add    $0x10,%esp
f010331a:	85 c0                	test   %eax,%eax
f010331c:	74 14                	je     f0103332 <mem_init+0xb22>
f010331e:	68 07 62 10 f0       	push   $0xf0106207
f0103323:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103328:	68 a1 03 00 00       	push   $0x3a1
f010332d:	e9 19 f6 ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(pp1->pp_ref);
f0103332:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0103337:	75 14                	jne    f010334d <mem_init+0xb3d>
f0103339:	68 3c 62 10 f0       	push   $0xf010623c
f010333e:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103343:	68 a2 03 00 00       	push   $0x3a2
f0103348:	e9 fe f5 ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(pp1->pp_link == NULL);
f010334d:	83 3b 00             	cmpl   $0x0,(%ebx)
f0103350:	74 14                	je     f0103366 <mem_init+0xb56>
f0103352:	68 48 62 10 f0       	push   $0xf0106248
f0103357:	68 2a 5b 10 f0       	push   $0xf0105b2a
f010335c:	68 a3 03 00 00       	push   $0x3a3
f0103361:	e9 e5 f5 ff ff       	jmp    f010294b <mem_init+0x13b>

	// unmapping pp1 at PGSIZE should free it
	page_remove(kern_pgdir, (void*) PGSIZE);
f0103366:	51                   	push   %ecx
f0103367:	51                   	push   %ecx
f0103368:	68 00 10 00 00       	push   $0x1000
f010336d:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f0103373:	e8 01 f4 ff ff       	call   f0102779 <page_remove>
	assert(check_va2pa(kern_pgdir, 0x0) == ~0);
f0103378:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f010337d:	31 d2                	xor    %edx,%edx
f010337f:	e8 ee ee ff ff       	call   f0102272 <check_va2pa>
f0103384:	83 c4 10             	add    $0x10,%esp
f0103387:	40                   	inc    %eax
f0103388:	74 14                	je     f010339e <mem_init+0xb8e>
f010338a:	68 e4 61 10 f0       	push   $0xf01061e4
f010338f:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103394:	68 a7 03 00 00       	push   $0x3a7
f0103399:	e9 ad f5 ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(check_va2pa(kern_pgdir, PGSIZE) == ~0);
f010339e:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f01033a3:	ba 00 10 00 00       	mov    $0x1000,%edx
f01033a8:	e8 c5 ee ff ff       	call   f0102272 <check_va2pa>
f01033ad:	40                   	inc    %eax
f01033ae:	74 14                	je     f01033c4 <mem_init+0xbb4>
f01033b0:	68 5d 62 10 f0       	push   $0xf010625d
f01033b5:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01033ba:	68 a8 03 00 00       	push   $0x3a8
f01033bf:	e9 87 f5 ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(pp1->pp_ref == 0);
f01033c4:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f01033c9:	74 14                	je     f01033df <mem_init+0xbcf>
f01033cb:	68 83 62 10 f0       	push   $0xf0106283
f01033d0:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01033d5:	68 a9 03 00 00       	push   $0x3a9
f01033da:	e9 6c f5 ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(pp2->pp_ref == 0);
f01033df:	66 83 7d 04 00       	cmpw   $0x0,0x4(%ebp)
f01033e4:	74 14                	je     f01033fa <mem_init+0xbea>
f01033e6:	68 b1 61 10 f0       	push   $0xf01061b1
f01033eb:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01033f0:	68 aa 03 00 00       	push   $0x3aa
f01033f5:	e9 51 f5 ff ff       	jmp    f010294b <mem_init+0x13b>

	// so it should be returned by page_alloc
	assert((pp = page_alloc(0)) && pp == pp1);
f01033fa:	83 ec 0c             	sub    $0xc,%esp
f01033fd:	6a 00                	push   $0x0
f01033ff:	e8 e1 f1 ff ff       	call   f01025e5 <page_alloc>
f0103404:	83 c4 10             	add    $0x10,%esp
f0103407:	85 c0                	test   %eax,%eax
f0103409:	89 c7                	mov    %eax,%edi
f010340b:	74 04                	je     f0103411 <mem_init+0xc01>
f010340d:	39 d8                	cmp    %ebx,%eax
f010340f:	74 14                	je     f0103425 <mem_init+0xc15>
f0103411:	68 94 62 10 f0       	push   $0xf0106294
f0103416:	68 2a 5b 10 f0       	push   $0xf0105b2a
f010341b:	68 ad 03 00 00       	push   $0x3ad
f0103420:	e9 26 f5 ff ff       	jmp    f010294b <mem_init+0x13b>

	// should be no free memory
	assert(!page_alloc(0));
f0103425:	83 ec 0c             	sub    $0xc,%esp
f0103428:	6a 00                	push   $0x0
f010342a:	e8 b6 f1 ff ff       	call   f01025e5 <page_alloc>
f010342f:	83 c4 10             	add    $0x10,%esp
f0103432:	85 c0                	test   %eax,%eax
f0103434:	74 14                	je     f010344a <mem_init+0xc3a>
f0103436:	68 b4 5d 10 f0       	push   $0xf0105db4
f010343b:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103440:	68 b0 03 00 00       	push   $0x3b0
f0103445:	e9 01 f5 ff ff       	jmp    f010294b <mem_init+0x13b>

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
f010344a:	8b 1d c8 76 11 f0    	mov    0xf01176c8,%ebx
f0103450:	89 f0                	mov    %esi,%eax
f0103452:	e8 91 ed ff ff       	call   f01021e8 <page2pa>
f0103457:	8b 13                	mov    (%ebx),%edx
f0103459:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
f010345f:	39 c2                	cmp    %eax,%edx
f0103461:	74 14                	je     f0103477 <mem_init+0xc67>
f0103463:	68 b5 5e 10 f0       	push   $0xf0105eb5
f0103468:	68 2a 5b 10 f0       	push   $0xf0105b2a
f010346d:	68 b3 03 00 00       	push   $0x3b3
f0103472:	e9 d4 f4 ff ff       	jmp    f010294b <mem_init+0x13b>
	kern_pgdir[0] = 0;
	assert(pp0->pp_ref == 1);
f0103477:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
	// should be no free memory
	assert(!page_alloc(0));

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
	kern_pgdir[0] = 0;
f010347c:	c7 03 00 00 00 00    	movl   $0x0,(%ebx)
	assert(pp0->pp_ref == 1);
f0103482:	74 14                	je     f0103498 <mem_init+0xc88>
f0103484:	68 1b 5f 10 f0       	push   $0xf0105f1b
f0103489:	68 2a 5b 10 f0       	push   $0xf0105b2a
f010348e:	68 b5 03 00 00       	push   $0x3b5
f0103493:	e9 b3 f4 ff ff       	jmp    f010294b <mem_init+0x13b>
	pp0->pp_ref = 0;

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f0103498:	83 ec 0c             	sub    $0xc,%esp

	// forcibly take pp0 back
	assert(PTE_ADDR(kern_pgdir[0]) == page2pa(pp0));
	kern_pgdir[0] = 0;
	assert(pp0->pp_ref == 1);
	pp0->pp_ref = 0;
f010349b:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
f01034a1:	56                   	push   %esi
f01034a2:	e8 7f f1 ff ff       	call   f0102626 <page_free>
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f01034a7:	83 c4 0c             	add    $0xc,%esp
f01034aa:	6a 01                	push   $0x1
f01034ac:	68 00 10 40 00       	push   $0x401000
f01034b1:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f01034b7:	e8 c3 f1 ff ff       	call   f010267f <pgdir_walk>
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f01034bc:	ba bc 03 00 00       	mov    $0x3bc,%edx
	pp0->pp_ref = 0;

	// check pointer arithmetic in pgdir_walk
	page_free(pp0);
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
f01034c1:	89 44 24 2c          	mov    %eax,0x2c(%esp)
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
f01034c5:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f01034ca:	8b 48 04             	mov    0x4(%eax),%ecx
f01034cd:	b8 ce 5a 10 f0       	mov    $0xf0105ace,%eax
f01034d2:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f01034d8:	e8 53 ed ff ff       	call   f0102230 <_kaddr>
	assert(ptep == ptep1 + PTX(va));
f01034dd:	83 c4 10             	add    $0x10,%esp
f01034e0:	83 c0 04             	add    $0x4,%eax
f01034e3:	39 44 24 1c          	cmp    %eax,0x1c(%esp)
f01034e7:	74 14                	je     f01034fd <mem_init+0xced>
f01034e9:	68 b6 62 10 f0       	push   $0xf01062b6
f01034ee:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01034f3:	68 bd 03 00 00       	push   $0x3bd
f01034f8:	e9 4e f4 ff ff       	jmp    f010294b <mem_init+0x13b>
	kern_pgdir[PDX(va)] = 0;
f01034fd:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f0103502:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
	pp0->pp_ref = 0;

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f0103509:	89 f0                	mov    %esi,%eax
	va = (void*)(PGSIZE * NPDENTRIES + PGSIZE);
	ptep = pgdir_walk(kern_pgdir, va, 1);
	ptep1 = (pte_t *) KADDR(PTE_ADDR(kern_pgdir[PDX(va)]));
	assert(ptep == ptep1 + PTX(va));
	kern_pgdir[PDX(va)] = 0;
	pp0->pp_ref = 0;
f010350b:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
f0103511:	e8 43 ed ff ff       	call   f0102259 <page2kva>
f0103516:	52                   	push   %edx
f0103517:	68 00 10 00 00       	push   $0x1000
f010351c:	68 ff 00 00 00       	push   $0xff
f0103521:	50                   	push   %eax
f0103522:	e8 a8 cc ff ff       	call   f01001cf <memset>
	page_free(pp0);
f0103527:	89 34 24             	mov    %esi,(%esp)
f010352a:	e8 f7 f0 ff ff       	call   f0102626 <page_free>
	pgdir_walk(kern_pgdir, 0x0, 1);
f010352f:	83 c4 0c             	add    $0xc,%esp
f0103532:	6a 01                	push   $0x1
f0103534:	6a 00                	push   $0x0
f0103536:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f010353c:	e8 3e f1 ff ff       	call   f010267f <pgdir_walk>
	ptep = (pte_t *) page2kva(pp0);
f0103541:	89 f0                	mov    %esi,%eax
f0103543:	e8 11 ed ff ff       	call   f0102259 <page2kva>
	for(i=0; i<NPTENTRIES; i++)
f0103548:	31 d2                	xor    %edx,%edx

	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
	page_free(pp0);
	pgdir_walk(kern_pgdir, 0x0, 1);
	ptep = (pte_t *) page2kva(pp0);
f010354a:	89 44 24 2c          	mov    %eax,0x2c(%esp)
f010354e:	83 c4 10             	add    $0x10,%esp
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
f0103551:	f6 04 90 01          	testb  $0x1,(%eax,%edx,4)
f0103555:	74 14                	je     f010356b <mem_init+0xd5b>
f0103557:	68 ce 62 10 f0       	push   $0xf01062ce
f010355c:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103561:	68 c7 03 00 00       	push   $0x3c7
f0103566:	e9 e0 f3 ff ff       	jmp    f010294b <mem_init+0x13b>
	// check that new page tables get cleared
	memset(page2kva(pp0), 0xFF, PGSIZE);
	page_free(pp0);
	pgdir_walk(kern_pgdir, 0x0, 1);
	ptep = (pte_t *) page2kva(pp0);
	for(i=0; i<NPTENTRIES; i++)
f010356b:	42                   	inc    %edx
f010356c:	81 fa 00 04 00 00    	cmp    $0x400,%edx
f0103572:	75 dd                	jne    f0103551 <mem_init+0xd41>
		assert((ptep[i] & PTE_P) == 0);
	kern_pgdir[0] = 0;
f0103574:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f0103579:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
	pp0->pp_ref = 0;

	// give free list back
	page_free_list = fl;
f010357f:	8b 44 24 08          	mov    0x8(%esp),%eax

	// free the pages we took
	page_free(pp0);
f0103583:	83 ec 0c             	sub    $0xc,%esp
	pgdir_walk(kern_pgdir, 0x0, 1);
	ptep = (pte_t *) page2kva(pp0);
	for(i=0; i<NPTENTRIES; i++)
		assert((ptep[i] & PTE_P) == 0);
	kern_pgdir[0] = 0;
	pp0->pp_ref = 0;
f0103586:	66 c7 46 04 00 00    	movw   $0x0,0x4(%esi)

	// give free list back
	page_free_list = fl;

	// free the pages we took
	page_free(pp0);
f010358c:	56                   	push   %esi
		assert((ptep[i] & PTE_P) == 0);
	kern_pgdir[0] = 0;
	pp0->pp_ref = 0;

	// give free list back
	page_free_list = fl;
f010358d:	a3 1c 4e 11 f0       	mov    %eax,0xf0114e1c

	// free the pages we took
	page_free(pp0);
f0103592:	e8 8f f0 ff ff       	call   f0102626 <page_free>
	page_free(pp1);
f0103597:	89 3c 24             	mov    %edi,(%esp)
f010359a:	e8 87 f0 ff ff       	call   f0102626 <page_free>
	page_free(pp2);
f010359f:	89 2c 24             	mov    %ebp,(%esp)
f01035a2:	e8 7f f0 ff ff       	call   f0102626 <page_free>

	printk("check_page() succeeded!\n");
f01035a7:	c7 04 24 e5 62 10 f0 	movl   $0xf01062e5,(%esp)
f01035ae:	e8 1d ec ff ff       	call   f01021d0 <printk>
	// Permissions:
	//    - the new image at UPAGES -- kernel R, user R
	//      (ie. perm = PTE_U | PTE_P)
	//    - pages itself -- kernel RW, user NONE
	// Your code goes here:
    boot_map_region(kern_pgdir, UPAGES, ROUNDUP((sizeof(struct PageInfo) * npages), PGSIZE), PADDR(pages), (PTE_U | PTE_P));
f01035b3:	8b 15 d0 76 11 f0    	mov    0xf01176d0,%edx
f01035b9:	b8 b1 00 00 00       	mov    $0xb1,%eax
f01035be:	e8 60 ef ff ff       	call   f0102523 <_paddr.clone.0>
f01035c3:	8b 15 c4 76 11 f0    	mov    0xf01176c4,%edx
f01035c9:	5b                   	pop    %ebx
f01035ca:	5e                   	pop    %esi
f01035cb:	8d 0c d5 ff 0f 00 00 	lea    0xfff(,%edx,8),%ecx
f01035d2:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f01035d7:	6a 05                	push   $0x5
f01035d9:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f01035df:	50                   	push   %eax
f01035e0:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f01035e5:	e8 02 f1 ff ff       	call   f01026ec <boot_map_region>
	//       the kernel overflows its stack, it will fault rather than
	//       overwrite memory.  Known as a "guard page".
	//     Permissions: kernel RW, user NONE
	// Your code goes here:
    /* TODO */
    boot_map_region(kern_pgdir,KSTACKTOP - KSTKSIZE,KSTKSIZE,PADDR(bootstack),PTE_W);
f01035ea:	ba 00 c0 10 f0       	mov    $0xf010c000,%edx
f01035ef:	b8 c0 00 00 00       	mov    $0xc0,%eax
f01035f4:	e8 2a ef ff ff       	call   f0102523 <_paddr.clone.0>
f01035f9:	5a                   	pop    %edx
f01035fa:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f01035ff:	59                   	pop    %ecx
f0103600:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0103605:	6a 02                	push   $0x2
f0103607:	50                   	push   %eax
f0103608:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f010360d:	e8 da f0 ff ff       	call   f01026ec <boot_map_region>
	// We might not have 2^32 - KERNBASE bytes of physical memory, but
	// we just set up the mapping anyway.
	// Permissions: kernel RW, user NONE
	// Your code goes here:
    /* TODO */
    boot_map_region(kern_pgdir,KERNBASE,0xffffffff-KERNBASE,0,PTE_W);
f0103612:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f0103617:	b9 ff ff ff 0f       	mov    $0xfffffff,%ecx
f010361c:	5f                   	pop    %edi
f010361d:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0103622:	5d                   	pop    %ebp
f0103623:	6a 02                	push   $0x2
f0103625:	6a 00                	push   $0x0
f0103627:	e8 c0 f0 ff ff       	call   f01026ec <boot_map_region>
	//////////////////////////////////////////////////////////////////////
	// Map VA range [IOPHYSMEM, EXTPHYSMEM) to PA range [IOPHYSMEM, EXTPHYSMEM)
    boot_map_region(kern_pgdir, IOPHYSMEM, ROUNDUP((EXTPHYSMEM - IOPHYSMEM), PGSIZE), IOPHYSMEM, (PTE_W) | (PTE_P));
f010362c:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
f0103631:	b9 00 00 06 00       	mov    $0x60000,%ecx
f0103636:	5b                   	pop    %ebx
f0103637:	ba 00 00 0a 00       	mov    $0xa0000,%edx
f010363c:	5e                   	pop    %esi
	pde_t *pgdir;

	pgdir = kern_pgdir;

    // check IO mem
    for (i = IOPHYSMEM; i < ROUNDUP(EXTPHYSMEM, PGSIZE); i += PGSIZE)
f010363d:	be 00 00 0a 00       	mov    $0xa0000,%esi
	// Your code goes here:
    /* TODO */
    boot_map_region(kern_pgdir,KERNBASE,0xffffffff-KERNBASE,0,PTE_W);
	//////////////////////////////////////////////////////////////////////
	// Map VA range [IOPHYSMEM, EXTPHYSMEM) to PA range [IOPHYSMEM, EXTPHYSMEM)
    boot_map_region(kern_pgdir, IOPHYSMEM, ROUNDUP((EXTPHYSMEM - IOPHYSMEM), PGSIZE), IOPHYSMEM, (PTE_W) | (PTE_P));
f0103642:	6a 03                	push   $0x3
f0103644:	68 00 00 0a 00       	push   $0xa0000
f0103649:	e8 9e f0 ff ff       	call   f01026ec <boot_map_region>
check_kern_pgdir(void)
{
	uint32_t i, n;
	pde_t *pgdir;

	pgdir = kern_pgdir;
f010364e:	8b 1d c8 76 11 f0    	mov    0xf01176c8,%ebx
f0103654:	83 c4 10             	add    $0x10,%esp

    // check IO mem
    for (i = IOPHYSMEM; i < ROUNDUP(EXTPHYSMEM, PGSIZE); i += PGSIZE)
		assert(check_va2pa(pgdir, i) == i);
f0103657:	89 f2                	mov    %esi,%edx
f0103659:	89 d8                	mov    %ebx,%eax
f010365b:	e8 12 ec ff ff       	call   f0102272 <check_va2pa>
f0103660:	39 f0                	cmp    %esi,%eax
f0103662:	74 14                	je     f0103678 <mem_init+0xe68>
f0103664:	68 fe 62 10 f0       	push   $0xf01062fe
f0103669:	68 2a 5b 10 f0       	push   $0xf0105b2a
f010366e:	68 05 03 00 00       	push   $0x305
f0103673:	e9 d3 f2 ff ff       	jmp    f010294b <mem_init+0x13b>
	pde_t *pgdir;

	pgdir = kern_pgdir;

    // check IO mem
    for (i = IOPHYSMEM; i < ROUNDUP(EXTPHYSMEM, PGSIZE); i += PGSIZE)
f0103678:	81 c6 00 10 00 00    	add    $0x1000,%esi
f010367e:	81 fe 00 00 10 00    	cmp    $0x100000,%esi
f0103684:	75 d1                	jne    f0103657 <mem_init+0xe47>
		assert(check_va2pa(pgdir, i) == i);

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f0103686:	a1 c4 76 11 f0       	mov    0xf01176c4,%eax
	for (i = 0; i < n; i += PGSIZE)
f010368b:	31 f6                	xor    %esi,%esi
    // check IO mem
    for (i = IOPHYSMEM; i < ROUNDUP(EXTPHYSMEM, PGSIZE); i += PGSIZE)
		assert(check_va2pa(pgdir, i) == i);

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
f010368d:	8d 3c c5 ff 0f 00 00 	lea    0xfff(,%eax,8),%edi
f0103694:	81 e7 00 f0 ff ff    	and    $0xfffff000,%edi
f010369a:	eb 3f                	jmp    f01036db <mem_init+0xecb>
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
f010369c:	8d 96 00 00 00 ef    	lea    -0x11000000(%esi),%edx
f01036a2:	89 d8                	mov    %ebx,%eax
f01036a4:	e8 c9 eb ff ff       	call   f0102272 <check_va2pa>
f01036a9:	8b 15 d0 76 11 f0    	mov    0xf01176d0,%edx
f01036af:	89 c5                	mov    %eax,%ebp
f01036b1:	b8 0a 03 00 00       	mov    $0x30a,%eax
f01036b6:	e8 68 ee ff ff       	call   f0102523 <_paddr.clone.0>
f01036bb:	01 f0                	add    %esi,%eax
f01036bd:	39 c5                	cmp    %eax,%ebp
f01036bf:	74 14                	je     f01036d5 <mem_init+0xec5>
f01036c1:	68 19 63 10 f0       	push   $0xf0106319
f01036c6:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01036cb:	68 0a 03 00 00       	push   $0x30a
f01036d0:	e9 76 f2 ff ff       	jmp    f010294b <mem_init+0x13b>
    for (i = IOPHYSMEM; i < ROUNDUP(EXTPHYSMEM, PGSIZE); i += PGSIZE)
		assert(check_va2pa(pgdir, i) == i);

	// check pages array
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
f01036d5:	81 c6 00 10 00 00    	add    $0x1000,%esi
f01036db:	39 fe                	cmp    %edi,%esi
f01036dd:	72 bd                	jb     f010369c <mem_init+0xe8c>
f01036df:	31 f6                	xor    %esi,%esi
f01036e1:	eb 2b                	jmp    f010370e <mem_init+0xefe>
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
    
	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
		assert(check_va2pa(pgdir, KERNBASE + i) == i);
f01036e3:	8d 96 00 00 00 f0    	lea    -0x10000000(%esi),%edx
f01036e9:	89 d8                	mov    %ebx,%eax
f01036eb:	e8 82 eb ff ff       	call   f0102272 <check_va2pa>
f01036f0:	39 f0                	cmp    %esi,%eax
f01036f2:	74 14                	je     f0103708 <mem_init+0xef8>
f01036f4:	68 4c 63 10 f0       	push   $0xf010634c
f01036f9:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01036fe:	68 0e 03 00 00       	push   $0x30e
f0103703:	e9 43 f2 ff ff       	jmp    f010294b <mem_init+0x13b>
	n = ROUNDUP(npages*sizeof(struct PageInfo), PGSIZE);
	for (i = 0; i < n; i += PGSIZE)
		assert(check_va2pa(pgdir, UPAGES + i) == PADDR(pages) + i);
    
	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
f0103708:	81 c6 00 10 00 00    	add    $0x1000,%esi
f010370e:	a1 c4 76 11 f0       	mov    0xf01176c4,%eax
f0103713:	c1 e0 0c             	shl    $0xc,%eax
f0103716:	39 c6                	cmp    %eax,%esi
f0103718:	72 c9                	jb     f01036e3 <mem_init+0xed3>
f010371a:	31 f6                	xor    %esi,%esi
		assert(check_va2pa(pgdir, KERNBASE + i) == i);

	// check kernel stack
	for (i = 0; i < KSTKSIZE; i += PGSIZE)
		assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);
f010371c:	8d 96 00 80 ff ef    	lea    -0x10008000(%esi),%edx
f0103722:	89 d8                	mov    %ebx,%eax
f0103724:	e8 49 eb ff ff       	call   f0102272 <check_va2pa>
f0103729:	ba 00 c0 10 f0       	mov    $0xf010c000,%edx
f010372e:	89 c7                	mov    %eax,%edi
f0103730:	b8 12 03 00 00       	mov    $0x312,%eax
f0103735:	e8 e9 ed ff ff       	call   f0102523 <_paddr.clone.0>
f010373a:	8d 04 06             	lea    (%esi,%eax,1),%eax
f010373d:	39 c7                	cmp    %eax,%edi
f010373f:	74 14                	je     f0103755 <mem_init+0xf45>
f0103741:	68 72 63 10 f0       	push   $0xf0106372
f0103746:	68 2a 5b 10 f0       	push   $0xf0105b2a
f010374b:	68 12 03 00 00       	push   $0x312
f0103750:	e9 f6 f1 ff ff       	jmp    f010294b <mem_init+0x13b>
	// check phys mem
	for (i = 0; i < npages * PGSIZE; i += PGSIZE)
		assert(check_va2pa(pgdir, KERNBASE + i) == i);

	// check kernel stack
	for (i = 0; i < KSTKSIZE; i += PGSIZE)
f0103755:	81 c6 00 10 00 00    	add    $0x1000,%esi
f010375b:	81 fe 00 80 00 00    	cmp    $0x8000,%esi
f0103761:	75 b9                	jne    f010371c <mem_init+0xf0c>
		assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);
	assert(check_va2pa(pgdir, KSTACKTOP - PTSIZE) == ~0);
f0103763:	ba 00 00 c0 ef       	mov    $0xefc00000,%edx
f0103768:	89 d8                	mov    %ebx,%eax
f010376a:	e8 03 eb ff ff       	call   f0102272 <check_va2pa>
f010376f:	31 d2                	xor    %edx,%edx
f0103771:	40                   	inc    %eax
f0103772:	74 14                	je     f0103788 <mem_init+0xf78>
f0103774:	68 b7 63 10 f0       	push   $0xf01063b7
f0103779:	68 2a 5b 10 f0       	push   $0xf0105b2a
f010377e:	68 13 03 00 00       	push   $0x313
f0103783:	e9 c3 f1 ff ff       	jmp    f010294b <mem_init+0x13b>

	// check PDE permissions
	for (i = 0; i < NPDENTRIES; i++) {
		switch (i) {
f0103788:	81 fa bd 03 00 00    	cmp    $0x3bd,%edx
f010378e:	77 0c                	ja     f010379c <mem_init+0xf8c>
f0103790:	81 fa bc 03 00 00    	cmp    $0x3bc,%edx
f0103796:	73 0c                	jae    f01037a4 <mem_init+0xf94>
f0103798:	85 d2                	test   %edx,%edx
f010379a:	eb 06                	jmp    f01037a2 <mem_init+0xf92>
f010379c:	81 fa bf 03 00 00    	cmp    $0x3bf,%edx
f01037a2:	75 1a                	jne    f01037be <mem_init+0xfae>
        case PDX(IOPHYSMEM):
		case PDX(UVPT):
		case PDX(KSTACKTOP-1):
		case PDX(UPAGES):
			assert(pgdir[i] & PTE_P);
f01037a4:	f6 04 93 01          	testb  $0x1,(%ebx,%edx,4)
f01037a8:	75 69                	jne    f0103813 <mem_init+0x1003>
f01037aa:	68 e4 63 10 f0       	push   $0xf01063e4
f01037af:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01037b4:	68 1c 03 00 00       	push   $0x31c
f01037b9:	e9 8d f1 ff ff       	jmp    f010294b <mem_init+0x13b>
			break;
		default:
			if (i >= PDX(KERNBASE)) {
f01037be:	81 fa bf 03 00 00    	cmp    $0x3bf,%edx
f01037c4:	76 33                	jbe    f01037f9 <mem_init+0xfe9>
				assert(pgdir[i] & PTE_P);
f01037c6:	8b 04 93             	mov    (%ebx,%edx,4),%eax
f01037c9:	a8 01                	test   $0x1,%al
f01037cb:	75 14                	jne    f01037e1 <mem_init+0xfd1>
f01037cd:	68 e4 63 10 f0       	push   $0xf01063e4
f01037d2:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01037d7:	68 20 03 00 00       	push   $0x320
f01037dc:	e9 6a f1 ff ff       	jmp    f010294b <mem_init+0x13b>
				assert(pgdir[i] & PTE_W);
f01037e1:	a8 02                	test   $0x2,%al
f01037e3:	75 2e                	jne    f0103813 <mem_init+0x1003>
f01037e5:	68 f5 63 10 f0       	push   $0xf01063f5
f01037ea:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01037ef:	68 21 03 00 00       	push   $0x321
f01037f4:	e9 52 f1 ff ff       	jmp    f010294b <mem_init+0x13b>
			} else
				assert(pgdir[i] == 0);
f01037f9:	83 3c 93 00          	cmpl   $0x0,(%ebx,%edx,4)
f01037fd:	74 14                	je     f0103813 <mem_init+0x1003>
f01037ff:	68 06 64 10 f0       	push   $0xf0106406
f0103804:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103809:	68 23 03 00 00       	push   $0x323
f010380e:	e9 38 f1 ff ff       	jmp    f010294b <mem_init+0x13b>
	for (i = 0; i < KSTKSIZE; i += PGSIZE)
		assert(check_va2pa(pgdir, KSTACKTOP - KSTKSIZE + i) == PADDR(bootstack) + i);
	assert(check_va2pa(pgdir, KSTACKTOP - PTSIZE) == ~0);

	// check PDE permissions
	for (i = 0; i < NPDENTRIES; i++) {
f0103813:	42                   	inc    %edx
f0103814:	81 fa 00 04 00 00    	cmp    $0x400,%edx
f010381a:	0f 85 68 ff ff ff    	jne    f0103788 <mem_init+0xf78>
			} else
				assert(pgdir[i] == 0);
			break;
		}
	}
	printk("check_kern_pgdir() succeeded!\n");
f0103820:	83 ec 0c             	sub    $0xc,%esp
f0103823:	68 14 64 10 f0       	push   $0xf0106414
f0103828:	e8 a3 e9 ff ff       	call   f01021d0 <printk>
	// somewhere between KERNBASE and KERNBASE+4MB right now, which is
	// mapped the same way by both page tables.
	//
	// If the machine reboots at this point, you've probably set up your
	// kern_pgdir wrong.
	lcr3(PADDR(kern_pgdir));
f010382d:	8b 15 c8 76 11 f0    	mov    0xf01176c8,%edx
f0103833:	b8 d9 00 00 00       	mov    $0xd9,%eax
f0103838:	e8 e6 ec ff ff       	call   f0102523 <_paddr.clone.0>
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f010383d:	0f 22 d8             	mov    %eax,%cr3

	check_page_free_list(0);
f0103840:	31 c0                	xor    %eax,%eax
f0103842:	e8 a3 ea ff ff       	call   f01022ea <check_page_free_list>

static __inline uint32_t
rcr0(void)
{
	uint32_t val;
	__asm __volatile("movl %%cr0,%0" : "=r" (val));
f0103847:	0f 20 c0             	mov    %cr0,%eax

	// entry.S set the really important flags in cr0 (including enabling
	// paging).  Here we configure the rest of the flags that we care about.
	cr0 = rcr0();
	cr0 |= CR0_PE|CR0_PG|CR0_AM|CR0_WP|CR0_NE|CR0_MP;
f010384a:	0d 23 00 05 80       	or     $0x80050023,%eax
	cr0 &= ~(CR0_TS|CR0_EM);
f010384f:	83 e0 f3             	and    $0xfffffff3,%eax
}

static __inline void
lcr0(uint32_t val)
{
	__asm __volatile("movl %0,%%cr0" : : "r" (val));
f0103852:	0f 22 c0             	mov    %eax,%cr0
{
	struct PageInfo *pp0, *pp1, *pp2;

	// check that we can read and write installed pages
	pp1 = pp2 = 0;
	assert((pp0 = page_alloc(0)));
f0103855:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f010385c:	e8 84 ed ff ff       	call   f01025e5 <page_alloc>
f0103861:	83 c4 10             	add    $0x10,%esp
f0103864:	85 c0                	test   %eax,%eax
f0103866:	89 c7                	mov    %eax,%edi
f0103868:	75 14                	jne    f010387e <mem_init+0x106e>
f010386a:	68 e9 5c 10 f0       	push   $0xf0105ce9
f010386f:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103874:	68 de 03 00 00       	push   $0x3de
f0103879:	e9 cd f0 ff ff       	jmp    f010294b <mem_init+0x13b>
	assert((pp1 = page_alloc(0)));
f010387e:	83 ec 0c             	sub    $0xc,%esp
f0103881:	6a 00                	push   $0x0
f0103883:	e8 5d ed ff ff       	call   f01025e5 <page_alloc>
f0103888:	83 c4 10             	add    $0x10,%esp
f010388b:	85 c0                	test   %eax,%eax
f010388d:	89 c6                	mov    %eax,%esi
f010388f:	75 14                	jne    f01038a5 <mem_init+0x1095>
f0103891:	68 ff 5c 10 f0       	push   $0xf0105cff
f0103896:	68 2a 5b 10 f0       	push   $0xf0105b2a
f010389b:	68 df 03 00 00       	push   $0x3df
f01038a0:	e9 a6 f0 ff ff       	jmp    f010294b <mem_init+0x13b>
	assert((pp2 = page_alloc(0)));
f01038a5:	83 ec 0c             	sub    $0xc,%esp
f01038a8:	6a 00                	push   $0x0
f01038aa:	e8 36 ed ff ff       	call   f01025e5 <page_alloc>
f01038af:	83 c4 10             	add    $0x10,%esp
f01038b2:	85 c0                	test   %eax,%eax
f01038b4:	89 c3                	mov    %eax,%ebx
f01038b6:	75 14                	jne    f01038cc <mem_init+0x10bc>
f01038b8:	68 15 5d 10 f0       	push   $0xf0105d15
f01038bd:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01038c2:	68 e0 03 00 00       	push   $0x3e0
f01038c7:	e9 7f f0 ff ff       	jmp    f010294b <mem_init+0x13b>
	page_free(pp0);
f01038cc:	83 ec 0c             	sub    $0xc,%esp
f01038cf:	57                   	push   %edi
f01038d0:	e8 51 ed ff ff       	call   f0102626 <page_free>
	memset(page2kva(pp1), 1, PGSIZE);
f01038d5:	89 f0                	mov    %esi,%eax
f01038d7:	e8 7d e9 ff ff       	call   f0102259 <page2kva>
f01038dc:	83 c4 0c             	add    $0xc,%esp
f01038df:	68 00 10 00 00       	push   $0x1000
f01038e4:	6a 01                	push   $0x1
f01038e6:	50                   	push   %eax
f01038e7:	e8 e3 c8 ff ff       	call   f01001cf <memset>
	memset(page2kva(pp2), 2, PGSIZE);
f01038ec:	89 d8                	mov    %ebx,%eax
f01038ee:	e8 66 e9 ff ff       	call   f0102259 <page2kva>
f01038f3:	83 c4 0c             	add    $0xc,%esp
f01038f6:	68 00 10 00 00       	push   $0x1000
f01038fb:	6a 02                	push   $0x2
f01038fd:	50                   	push   %eax
f01038fe:	e8 cc c8 ff ff       	call   f01001cf <memset>
	page_insert(kern_pgdir, pp1, (void*) EXTPHYSMEM, PTE_W);
f0103903:	6a 02                	push   $0x2
f0103905:	68 00 00 10 00       	push   $0x100000
f010390a:	56                   	push   %esi
f010390b:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f0103911:	e8 9f ee ff ff       	call   f01027b5 <page_insert>
	assert(pp1->pp_ref == 1);
f0103916:	83 c4 20             	add    $0x20,%esp
f0103919:	66 83 7e 04 01       	cmpw   $0x1,0x4(%esi)
f010391e:	74 14                	je     f0103934 <mem_init+0x1124>
f0103920:	68 0a 5f 10 f0       	push   $0xf0105f0a
f0103925:	68 2a 5b 10 f0       	push   $0xf0105b2a
f010392a:	68 e5 03 00 00       	push   $0x3e5
f010392f:	e9 17 f0 ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(*(uint32_t *)EXTPHYSMEM == 0x01010101U);
f0103934:	81 3d 00 00 10 00 01 	cmpl   $0x1010101,0x100000
f010393b:	01 01 01 
f010393e:	74 14                	je     f0103954 <mem_init+0x1144>
f0103940:	68 33 64 10 f0       	push   $0xf0106433
f0103945:	68 2a 5b 10 f0       	push   $0xf0105b2a
f010394a:	68 e6 03 00 00       	push   $0x3e6
f010394f:	e9 f7 ef ff ff       	jmp    f010294b <mem_init+0x13b>
	page_insert(kern_pgdir, pp2, (void*) EXTPHYSMEM, PTE_W);
f0103954:	6a 02                	push   $0x2
f0103956:	68 00 00 10 00       	push   $0x100000
f010395b:	53                   	push   %ebx
f010395c:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f0103962:	e8 4e ee ff ff       	call   f01027b5 <page_insert>
	assert(*(uint32_t *)EXTPHYSMEM == 0x02020202U);
f0103967:	83 c4 10             	add    $0x10,%esp
f010396a:	81 3d 00 00 10 00 02 	cmpl   $0x2020202,0x100000
f0103971:	02 02 02 
f0103974:	74 14                	je     f010398a <mem_init+0x117a>
f0103976:	68 5a 64 10 f0       	push   $0xf010645a
f010397b:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103980:	68 e8 03 00 00       	push   $0x3e8
f0103985:	e9 c1 ef ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(pp2->pp_ref == 1);
f010398a:	66 83 7b 04 01       	cmpw   $0x1,0x4(%ebx)
f010398f:	74 14                	je     f01039a5 <mem_init+0x1195>
f0103991:	68 95 5f 10 f0       	push   $0xf0105f95
f0103996:	68 2a 5b 10 f0       	push   $0xf0105b2a
f010399b:	68 e9 03 00 00       	push   $0x3e9
f01039a0:	e9 a6 ef ff ff       	jmp    f010294b <mem_init+0x13b>
	assert(pp1->pp_ref == 0);
f01039a5:	66 83 7e 04 00       	cmpw   $0x0,0x4(%esi)
f01039aa:	74 14                	je     f01039c0 <mem_init+0x11b0>
f01039ac:	68 83 62 10 f0       	push   $0xf0106283
f01039b1:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01039b6:	68 ea 03 00 00       	push   $0x3ea
f01039bb:	e9 8b ef ff ff       	jmp    f010294b <mem_init+0x13b>
	*(uint32_t *)EXTPHYSMEM = 0x03030303U;
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f01039c0:	89 d8                	mov    %ebx,%eax
	assert(*(uint32_t *)EXTPHYSMEM == 0x01010101U);
	page_insert(kern_pgdir, pp2, (void*) EXTPHYSMEM, PTE_W);
	assert(*(uint32_t *)EXTPHYSMEM == 0x02020202U);
	assert(pp2->pp_ref == 1);
	assert(pp1->pp_ref == 0);
	*(uint32_t *)EXTPHYSMEM = 0x03030303U;
f01039c2:	c7 05 00 00 10 00 03 	movl   $0x3030303,0x100000
f01039c9:	03 03 03 
	assert(*(uint32_t *)page2kva(pp2) == 0x03030303U);
f01039cc:	e8 88 e8 ff ff       	call   f0102259 <page2kva>
f01039d1:	81 38 03 03 03 03    	cmpl   $0x3030303,(%eax)
f01039d7:	74 14                	je     f01039ed <mem_init+0x11dd>
f01039d9:	68 81 64 10 f0       	push   $0xf0106481
f01039de:	68 2a 5b 10 f0       	push   $0xf0105b2a
f01039e3:	68 ec 03 00 00       	push   $0x3ec
f01039e8:	e9 5e ef ff ff       	jmp    f010294b <mem_init+0x13b>
	page_remove(kern_pgdir, (void*) EXTPHYSMEM);
f01039ed:	51                   	push   %ecx
f01039ee:	51                   	push   %ecx
f01039ef:	68 00 00 10 00       	push   $0x100000
f01039f4:	ff 35 c8 76 11 f0    	pushl  0xf01176c8
f01039fa:	e8 7a ed ff ff       	call   f0102779 <page_remove>
	assert(pp2->pp_ref == 0);
f01039ff:	83 c4 10             	add    $0x10,%esp
f0103a02:	66 83 7b 04 00       	cmpw   $0x0,0x4(%ebx)
f0103a07:	74 14                	je     f0103a1d <mem_init+0x120d>
f0103a09:	68 b1 61 10 f0       	push   $0xf01061b1
f0103a0e:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103a13:	68 ee 03 00 00       	push   $0x3ee
f0103a18:	e9 2e ef ff ff       	jmp    f010294b <mem_init+0x13b>

	printk("check_page_installed_pgdir() succeeded!\n");
f0103a1d:	83 ec 0c             	sub    $0xc,%esp
f0103a20:	68 ab 64 10 f0       	push   $0xf01064ab
f0103a25:	e8 a6 e7 ff ff       	call   f01021d0 <printk>
	cr0 &= ~(CR0_TS|CR0_EM);
	lcr0(cr0);

	// Some more checks, only possible after kern_pgdir is installed.
	check_page_installed_pgdir();
}
f0103a2a:	83 c4 3c             	add    $0x3c,%esp
f0103a2d:	5b                   	pop    %ebx
f0103a2e:	5e                   	pop    %esi
f0103a2f:	5f                   	pop    %edi
f0103a30:	5d                   	pop    %ebp
f0103a31:	c3                   	ret    

f0103a32 <ptable_remove>:
    tlb_invalidate(pgdir, va);
}

void
ptable_remove(pde_t *pgdir)
{
f0103a32:	56                   	push   %esi
f0103a33:	53                   	push   %ebx
  int i;
  /* Free Page Tables */
  for (i = 0; i < 1024; i++)
f0103a34:	31 db                	xor    %ebx,%ebx
    tlb_invalidate(pgdir, va);
}

void
ptable_remove(pde_t *pgdir)
{
f0103a36:	83 ec 04             	sub    $0x4,%esp
f0103a39:	8b 74 24 10          	mov    0x10(%esp),%esi
  int i;
  /* Free Page Tables */
  for (i = 0; i < 1024; i++)
  {
    if (pgdir[i] & PTE_P)
f0103a3d:	8b 04 9e             	mov    (%esi,%ebx,4),%eax
f0103a40:	a8 01                	test   $0x1,%al
f0103a42:	74 16                	je     f0103a5a <ptable_remove+0x28>
      page_decref(pa2page(PTE_ADDR(pgdir[i])));
f0103a44:	25 00 f0 ff ff       	and    $0xfffff000,%eax
f0103a49:	e8 6f e8 ff ff       	call   f01022bd <pa2page>
f0103a4e:	83 ec 0c             	sub    $0xc,%esp
f0103a51:	50                   	push   %eax
f0103a52:	e8 08 ec ff ff       	call   f010265f <page_decref>
f0103a57:	83 c4 10             	add    $0x10,%esp
void
ptable_remove(pde_t *pgdir)
{
  int i;
  /* Free Page Tables */
  for (i = 0; i < 1024; i++)
f0103a5a:	43                   	inc    %ebx
f0103a5b:	81 fb 00 04 00 00    	cmp    $0x400,%ebx
f0103a61:	75 da                	jne    f0103a3d <ptable_remove+0xb>
  {
    if (pgdir[i] & PTE_P)
      page_decref(pa2page(PTE_ADDR(pgdir[i])));
  }
}
f0103a63:	83 c4 04             	add    $0x4,%esp
f0103a66:	5b                   	pop    %ebx
f0103a67:	5e                   	pop    %esi
f0103a68:	c3                   	ret    

f0103a69 <pgdir_remove>:


void
pgdir_remove(pde_t *pgdir)
{
f0103a69:	83 ec 0c             	sub    $0xc,%esp
  page_free(pa2page(PADDR(pgdir)));
f0103a6c:	b8 20 02 00 00       	mov    $0x220,%eax
f0103a71:	8b 54 24 10          	mov    0x10(%esp),%edx
f0103a75:	e8 a9 ea ff ff       	call   f0102523 <_paddr.clone.0>
f0103a7a:	e8 3e e8 ff ff       	call   f01022bd <pa2page>
f0103a7f:	89 44 24 10          	mov    %eax,0x10(%esp)
}
f0103a83:	83 c4 0c             	add    $0xc,%esp


void
pgdir_remove(pde_t *pgdir)
{
  page_free(pa2page(PADDR(pgdir)));
f0103a86:	e9 9b eb ff ff       	jmp    f0102626 <page_free>

f0103a8b <tlb_invalidate>:
}

static __inline void
invlpg(void *addr)
{
	__asm __volatile("invlpg (%0)" : : "r" (addr) : "memory");
f0103a8b:	8b 44 24 08          	mov    0x8(%esp),%eax
f0103a8f:	0f 01 38             	invlpg (%eax)
tlb_invalidate(pde_t *pgdir, void *va)
{
	// Flush the entry only if we're modifying the current address space.
	// For now, there is only one address space, so always invalidate.
	invlpg(va);
}
f0103a92:	c3                   	ret    

f0103a93 <setupvm>:


/* This is a simple wrapper function for mapping user program */
void
setupvm(pde_t *pgdir, uint32_t start, uint32_t size)
{
f0103a93:	56                   	push   %esi
  boot_map_region(pgdir, start, ROUNDUP(size, PGSIZE), PADDR((void*)start), PTE_W | PTE_U);
f0103a94:	b8 34 02 00 00       	mov    $0x234,%eax


/* This is a simple wrapper function for mapping user program */
void
setupvm(pde_t *pgdir, uint32_t start, uint32_t size)
{
f0103a99:	53                   	push   %ebx
f0103a9a:	83 ec 04             	sub    $0x4,%esp
f0103a9d:	8b 5c 24 14          	mov    0x14(%esp),%ebx
f0103aa1:	8b 74 24 10          	mov    0x10(%esp),%esi
  boot_map_region(pgdir, start, ROUNDUP(size, PGSIZE), PADDR((void*)start), PTE_W | PTE_U);
f0103aa5:	89 da                	mov    %ebx,%edx
f0103aa7:	e8 77 ea ff ff       	call   f0102523 <_paddr.clone.0>
f0103aac:	8b 4c 24 18          	mov    0x18(%esp),%ecx
f0103ab0:	81 c1 ff 0f 00 00    	add    $0xfff,%ecx
f0103ab6:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0103abc:	52                   	push   %edx
f0103abd:	52                   	push   %edx
f0103abe:	89 da                	mov    %ebx,%edx
f0103ac0:	6a 06                	push   $0x6
f0103ac2:	50                   	push   %eax
f0103ac3:	89 f0                	mov    %esi,%eax
f0103ac5:	e8 22 ec ff ff       	call   f01026ec <boot_map_region>
  assert(check_va2pa(pgdir, start) == PADDR((void*)start));
f0103aca:	89 da                	mov    %ebx,%edx
f0103acc:	89 f0                	mov    %esi,%eax
f0103ace:	e8 9f e7 ff ff       	call   f0102272 <check_va2pa>
f0103ad3:	89 da                	mov    %ebx,%edx
f0103ad5:	89 c6                	mov    %eax,%esi
f0103ad7:	b8 35 02 00 00       	mov    $0x235,%eax
f0103adc:	e8 42 ea ff ff       	call   f0102523 <_paddr.clone.0>
f0103ae1:	83 c4 10             	add    $0x10,%esp
f0103ae4:	39 c6                	cmp    %eax,%esi
f0103ae6:	74 19                	je     f0103b01 <setupvm+0x6e>
f0103ae8:	68 d4 64 10 f0       	push   $0xf01064d4
f0103aed:	68 2a 5b 10 f0       	push   $0xf0105b2a
f0103af2:	68 35 02 00 00       	push   $0x235
f0103af7:	68 ce 5a 10 f0       	push   $0xf0105ace
f0103afc:	e8 e7 00 00 00       	call   f0103be8 <_panic>
}
f0103b01:	83 c4 04             	add    $0x4,%esp
f0103b04:	5b                   	pop    %ebx
f0103b05:	5e                   	pop    %esi
f0103b06:	c3                   	ret    

f0103b07 <setupkvm>:
 * You should map the kernel part memory with appropriate permission
 * Return a pointer to newly created page directory
 */
pde_t *
setupkvm()
{
f0103b07:	53                   	push   %ebx
f0103b08:	83 ec 14             	sub    $0x14,%esp
    struct PageInfo *s;
    s = page_alloc(ALLOC_ZERO);
f0103b0b:	6a 01                	push   $0x1
f0103b0d:	e8 d3 ea ff ff       	call   f01025e5 <page_alloc>
    pde_t u_pgdir = page2kva(s);
f0103b12:	e8 42 e7 ff ff       	call   f0102259 <page2kva>
    boot_map_region(u_pgdir, UPAGES, ROUNDUP((sizeof(struct PageInfo) * npages), PGSIZE), PADDR(pages), (PTE_U | PTE_P));
f0103b17:	8b 15 d0 76 11 f0    	mov    0xf01176d0,%edx
pde_t *
setupkvm()
{
    struct PageInfo *s;
    s = page_alloc(ALLOC_ZERO);
    pde_t u_pgdir = page2kva(s);
f0103b1d:	89 c3                	mov    %eax,%ebx
    boot_map_region(u_pgdir, UPAGES, ROUNDUP((sizeof(struct PageInfo) * npages), PGSIZE), PADDR(pages), (PTE_U | PTE_P));
f0103b1f:	b8 44 02 00 00       	mov    $0x244,%eax
f0103b24:	e8 fa e9 ff ff       	call   f0102523 <_paddr.clone.0>
f0103b29:	8b 15 c4 76 11 f0    	mov    0xf01176c4,%edx
f0103b2f:	8d 0c d5 ff 0f 00 00 	lea    0xfff(,%edx,8),%ecx
f0103b36:	5a                   	pop    %edx
f0103b37:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
f0103b3d:	5a                   	pop    %edx
f0103b3e:	ba 00 00 00 ef       	mov    $0xef000000,%edx
f0103b43:	6a 05                	push   $0x5
f0103b45:	50                   	push   %eax
f0103b46:	89 d8                	mov    %ebx,%eax
f0103b48:	e8 9f eb ff ff       	call   f01026ec <boot_map_region>
    boot_map_region(u_pgdir,KSTACKTOP - KSTKSIZE,KSTKSIZE,PADDR(bootstack),PTE_W);
f0103b4d:	ba 00 c0 10 f0       	mov    $0xf010c000,%edx
f0103b52:	b8 45 02 00 00       	mov    $0x245,%eax
f0103b57:	e8 c7 e9 ff ff       	call   f0102523 <_paddr.clone.0>
f0103b5c:	5a                   	pop    %edx
f0103b5d:	ba 00 80 ff ef       	mov    $0xefff8000,%edx
f0103b62:	59                   	pop    %ecx
f0103b63:	b9 00 80 00 00       	mov    $0x8000,%ecx
f0103b68:	6a 02                	push   $0x2
f0103b6a:	50                   	push   %eax
f0103b6b:	89 d8                	mov    %ebx,%eax
f0103b6d:	e8 7a eb ff ff       	call   f01026ec <boot_map_region>
    boot_map_region(u_pgdir,KERNBASE,0xffffffff-KERNBASE,0,PTE_W);
f0103b72:	89 d8                	mov    %ebx,%eax
f0103b74:	5a                   	pop    %edx
f0103b75:	ba 00 00 00 f0       	mov    $0xf0000000,%edx
f0103b7a:	59                   	pop    %ecx
f0103b7b:	b9 ff ff ff 0f       	mov    $0xfffffff,%ecx
f0103b80:	6a 02                	push   $0x2
f0103b82:	6a 00                	push   $0x0
f0103b84:	e8 63 eb ff ff       	call   f01026ec <boot_map_region>
    boot_map_region(u_pgdir, IOPHYSMEM, ROUNDUP((EXTPHYSMEM - IOPHYSMEM), PGSIZE), IOPHYSMEM, (PTE_W) | (PTE_P));
f0103b89:	ba 00 00 0a 00       	mov    $0xa0000,%edx
f0103b8e:	59                   	pop    %ecx
f0103b8f:	b9 00 00 06 00       	mov    $0x60000,%ecx
f0103b94:	58                   	pop    %eax
f0103b95:	89 d8                	mov    %ebx,%eax
f0103b97:	6a 03                	push   $0x3
f0103b99:	68 00 00 0a 00       	push   $0xa0000
f0103b9e:	e8 49 eb ff ff       	call   f01026ec <boot_map_region>
    return u_pgdir;
}
f0103ba3:	89 d8                	mov    %ebx,%eax
f0103ba5:	83 c4 18             	add    $0x18,%esp
f0103ba8:	5b                   	pop    %ebx
f0103ba9:	c3                   	ret    

f0103baa <sys_get_num_free_page>:
 * Please maintain num_free_pages yourself
 */
/* This is the system call implementation of get_num_free_page */
int32_t
sys_get_num_free_page(void)
{
f0103baa:	53                   	push   %ebx
/* TODO: Lab 5
 * Please maintain num_free_pages yourself
 */
/* This is the system call implementation of get_num_free_page */
int32_t
sys_get_num_free_page(void)
f0103bab:	8b 0d c4 76 11 f0    	mov    0xf01176c4,%ecx
{
    int i = 0;
    num_free_pages = 0;
    for(i=0;i<npages;i++)
f0103bb1:	31 c0                	xor    %eax,%eax
    {
        if(pages[i].pp_ref==0)
f0103bb3:	8b 1d d0 76 11 f0    	mov    0xf01176d0,%ebx
int32_t
sys_get_num_free_page(void)
{
    int i = 0;
    num_free_pages = 0;
    for(i=0;i<npages;i++)
f0103bb9:	31 d2                	xor    %edx,%edx
f0103bbb:	eb 0a                	jmp    f0103bc7 <sys_get_num_free_page+0x1d>
    {
        if(pages[i].pp_ref==0)
            num_free_pages++;
f0103bbd:	66 83 7c d3 04 01    	cmpw   $0x1,0x4(%ebx,%edx,8)
f0103bc3:	83 d0 00             	adc    $0x0,%eax
int32_t
sys_get_num_free_page(void)
{
    int i = 0;
    num_free_pages = 0;
    for(i=0;i<npages;i++)
f0103bc6:	42                   	inc    %edx
f0103bc7:	39 ca                	cmp    %ecx,%edx
f0103bc9:	75 f2                	jne    f0103bbd <sys_get_num_free_page+0x13>
f0103bcb:	a3 cc 76 11 f0       	mov    %eax,0xf01176cc
    {
        if(pages[i].pp_ref==0)
            num_free_pages++;
    }
    return num_free_pages;
}
f0103bd0:	5b                   	pop    %ebx
f0103bd1:	c3                   	ret    

f0103bd2 <sys_get_num_used_page>:

/* This is the system call implementation of get_num_used_page */
int32_t
sys_get_num_used_page(void)
{
    num_free_pages = sys_get_num_free_page();
f0103bd2:	e8 d3 ff ff ff       	call   f0103baa <sys_get_num_free_page>
f0103bd7:	89 c2                	mov    %eax,%edx
f0103bd9:	a3 cc 76 11 f0       	mov    %eax,0xf01176cc
    return npages - num_free_pages; 
f0103bde:	a1 c4 76 11 f0       	mov    0xf01176c4,%eax
f0103be3:	29 d0                	sub    %edx,%eax
}
f0103be5:	c3                   	ret    
	...

f0103be8 <_panic>:
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f0103be8:	56                   	push   %esi
f0103be9:	53                   	push   %ebx
f0103bea:	83 ec 04             	sub    $0x4,%esp
	va_list ap;

	if (panicstr)
f0103bed:	83 3d d4 76 11 f0 00 	cmpl   $0x0,0xf01176d4
 * Panic is called on unresolvable fatal errors.
 * It prints "panic: mesg", and then enters the kernel monitor.
 */
void
_panic(const char *file, int line, const char *fmt,...)
{
f0103bf4:	8b 5c 24 18          	mov    0x18(%esp),%ebx
	va_list ap;

	if (panicstr)
f0103bf8:	75 37                	jne    f0103c31 <_panic+0x49>
		goto dead;
	panicstr = fmt;
f0103bfa:	89 1d d4 76 11 f0    	mov    %ebx,0xf01176d4

	// Be extra sure that the machine is in as reasonable state
	__asm __volatile("cli; cld");
f0103c00:	fa                   	cli    
f0103c01:	fc                   	cld    

	va_start(ap, fmt);
f0103c02:	8d 74 24 1c          	lea    0x1c(%esp),%esi
	printk("kernel panic at %s:%d: ", file, line);
f0103c06:	51                   	push   %ecx
f0103c07:	ff 74 24 18          	pushl  0x18(%esp)
f0103c0b:	ff 74 24 18          	pushl  0x18(%esp)
f0103c0f:	68 05 65 10 f0       	push   $0xf0106505
f0103c14:	e8 b7 e5 ff ff       	call   f01021d0 <printk>
	vprintk(fmt, ap);
f0103c19:	58                   	pop    %eax
f0103c1a:	5a                   	pop    %edx
f0103c1b:	56                   	push   %esi
f0103c1c:	53                   	push   %ebx
f0103c1d:	e8 84 e5 ff ff       	call   f01021a6 <vprintk>
	printk("\n");
f0103c22:	c7 04 24 06 58 10 f0 	movl   $0xf0105806,(%esp)
f0103c29:	e8 a2 e5 ff ff       	call   f01021d0 <printk>
	va_end(ap);
f0103c2e:	83 c4 10             	add    $0x10,%esp
f0103c31:	eb fe                	jmp    f0103c31 <_panic+0x49>

f0103c33 <_warn>:
}

/* like panic, but don't */
void
_warn(const char *file, int line, const char *fmt,...)
{
f0103c33:	53                   	push   %ebx
f0103c34:	83 ec 08             	sub    $0x8,%esp
	va_list ap;

	va_start(ap, fmt);
f0103c37:	8d 5c 24 1c          	lea    0x1c(%esp),%ebx
	printk("kernel warning at %s:%d: ", file, line);
f0103c3b:	51                   	push   %ecx
f0103c3c:	ff 74 24 18          	pushl  0x18(%esp)
f0103c40:	ff 74 24 18          	pushl  0x18(%esp)
f0103c44:	68 1d 65 10 f0       	push   $0xf010651d
f0103c49:	e8 82 e5 ff ff       	call   f01021d0 <printk>
	vprintk(fmt, ap);
f0103c4e:	58                   	pop    %eax
f0103c4f:	5a                   	pop    %edx
f0103c50:	53                   	push   %ebx
f0103c51:	ff 74 24 24          	pushl  0x24(%esp)
f0103c55:	e8 4c e5 ff ff       	call   f01021a6 <vprintk>
	printk("\n");
f0103c5a:	c7 04 24 06 58 10 f0 	movl   $0xf0105806,(%esp)
f0103c61:	e8 6a e5 ff ff       	call   f01021d0 <printk>
	va_end(ap);
}
f0103c66:	83 c4 18             	add    $0x18,%esp
f0103c69:	5b                   	pop    %ebx
f0103c6a:	c3                   	ret    
	...

f0103c6c <mc146818_read>:
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103c6c:	8b 44 24 04          	mov    0x4(%esp),%eax
f0103c70:	ba 70 00 00 00       	mov    $0x70,%edx
f0103c75:	ee                   	out    %al,(%dx)

static __inline uint8_t
inb(int port)
{
	uint8_t data;
	__asm __volatile("inb %w1,%0" : "=a" (data) : "d" (port));
f0103c76:	b2 71                	mov    $0x71,%dl
f0103c78:	ec                   	in     (%dx),%al

unsigned
mc146818_read(unsigned reg)
{
	outb(IO_RTC, reg);
	return inb(IO_RTC+1);
f0103c79:	0f b6 c0             	movzbl %al,%eax
}
f0103c7c:	c3                   	ret    

f0103c7d <mc146818_write>:
}

static __inline void
outb(int port, uint8_t data)
{
	__asm __volatile("outb %0,%w1" : : "a" (data), "d" (port));
f0103c7d:	ba 70 00 00 00       	mov    $0x70,%edx
f0103c82:	8b 44 24 04          	mov    0x4(%esp),%eax
f0103c86:	ee                   	out    %al,(%dx)
f0103c87:	b2 71                	mov    $0x71,%dl
f0103c89:	8b 44 24 08          	mov    0x8(%esp),%eax
f0103c8d:	ee                   	out    %al,(%dx)
void
mc146818_write(unsigned reg, unsigned datum)
{
	outb(IO_RTC, reg);
	outb(IO_RTC+1, datum);
}
f0103c8e:	c3                   	ret    
	...

f0103c90 <timer_handler>:
  outb(0x40, divisor >> 8);     /* Set high byte of divisor */
}

/* It is timer interrupt handler */
void timer_handler(struct Trapframe *tf)
{
f0103c90:	53                   	push   %ebx
f0103c91:	83 ec 08             	sub    $0x8,%esp
  extern void sched_yield();
  int i;

  jiffies++;
f0103c94:	ff 05 28 4e 11 f0    	incl   0xf0114e28

  extern Task tasks[];

  extern Task *cur_task;

  if (cur_task != NULL)
f0103c9a:	83 3d 2c 4e 11 f0 00 	cmpl   $0x0,0xf0114e2c
f0103ca1:	74 4d                	je     f0103cf0 <timer_handler+0x60>
f0103ca3:	31 db                	xor    %ebx,%ebx
   *
   */
        int i;
        for(i = 0;i<NR_TASKS;i++)
        {
            if(tasks[i].state ==TASK_SLEEP)
f0103ca5:	83 bb 28 77 11 f0 03 	cmpl   $0x3,-0xfee88d8(%ebx)
f0103cac:	75 1b                	jne    f0103cc9 <timer_handler+0x39>
            {
                tasks[i].remind_ticks--;
f0103cae:	8b 83 24 77 11 f0    	mov    -0xfee88dc(%ebx),%eax
f0103cb4:	48                   	dec    %eax
                if(tasks[i].remind_ticks==0)
f0103cb5:	85 c0                	test   %eax,%eax
        int i;
        for(i = 0;i<NR_TASKS;i++)
        {
            if(tasks[i].state ==TASK_SLEEP)
            {
                tasks[i].remind_ticks--;
f0103cb7:	89 83 24 77 11 f0    	mov    %eax,-0xfee88dc(%ebx)
                if(tasks[i].remind_ticks==0)
f0103cbd:	75 0a                	jne    f0103cc9 <timer_handler+0x39>
                    tasks[i].state = TASK_RUNNABLE;
f0103cbf:	c7 83 28 77 11 f0 01 	movl   $0x1,-0xfee88d8(%ebx)
f0103cc6:	00 00 00 
            }
            cur_task->remind_ticks--;
f0103cc9:	a1 2c 4e 11 f0       	mov    0xf0114e2c,%eax
f0103cce:	8b 50 4c             	mov    0x4c(%eax),%edx
f0103cd1:	4a                   	dec    %edx
            if(cur_task->remind_ticks==0)
f0103cd2:	85 d2                	test   %edx,%edx
            {
                tasks[i].remind_ticks--;
                if(tasks[i].remind_ticks==0)
                    tasks[i].state = TASK_RUNNABLE;
            }
            cur_task->remind_ticks--;
f0103cd4:	89 50 4c             	mov    %edx,0x4c(%eax)
            if(cur_task->remind_ticks==0)
f0103cd7:	75 0c                	jne    f0103ce5 <timer_handler+0x55>
            {
                cur_task->state = TASK_RUNNABLE;
f0103cd9:	c7 40 50 01 00 00 00 	movl   $0x1,0x50(%eax)
                sched_yield();
f0103ce0:	e8 fb 05 00 00       	call   f01042e0 <sched_yield>
f0103ce5:	83 c3 58             	add    $0x58,%ebx
   *
   * 4. sched_yield() if the time is up for current task
   *
   */
        int i;
        for(i = 0;i<NR_TASKS;i++)
f0103ce8:	81 fb 70 03 00 00    	cmp    $0x370,%ebx
f0103cee:	75 b5                	jne    f0103ca5 <timer_handler+0x15>
                sched_yield();
            }
        }
    }
    
}
f0103cf0:	83 c4 08             	add    $0x8,%esp
f0103cf3:	5b                   	pop    %ebx
f0103cf4:	c3                   	ret    

f0103cf5 <set_timer>:

static unsigned long jiffies = 0;

void set_timer(int hz)
{
  int divisor = 1193180 / hz;       /* Calculate our divisor */
f0103cf5:	b9 dc 34 12 00       	mov    $0x1234dc,%ecx
f0103cfa:	89 c8                	mov    %ecx,%eax
f0103cfc:	99                   	cltd   
f0103cfd:	f7 7c 24 04          	idivl  0x4(%esp)
f0103d01:	ba 43 00 00 00       	mov    $0x43,%edx
f0103d06:	89 c1                	mov    %eax,%ecx
f0103d08:	b0 36                	mov    $0x36,%al
f0103d0a:	ee                   	out    %al,(%dx)
f0103d0b:	b2 40                	mov    $0x40,%dl
f0103d0d:	88 c8                	mov    %cl,%al
f0103d0f:	ee                   	out    %al,(%dx)
  outb(0x43, 0x36);             /* Set our command byte 0x36 */
  outb(0x40, divisor & 0xFF);   /* Set low byte of divisor */
  outb(0x40, divisor >> 8);     /* Set high byte of divisor */
f0103d10:	89 c8                	mov    %ecx,%eax
f0103d12:	c1 f8 08             	sar    $0x8,%eax
f0103d15:	ee                   	out    %al,(%dx)
}
f0103d16:	c3                   	ret    

f0103d17 <sys_get_ticks>:


unsigned long sys_get_ticks()
{
  return jiffies;
}
f0103d17:	a1 28 4e 11 f0       	mov    0xf0114e28,%eax
f0103d1c:	c3                   	ret    

f0103d1d <timer_init>:
void timer_init()
{
f0103d1d:	83 ec 0c             	sub    $0xc,%esp
  set_timer(TIME_HZ);
f0103d20:	6a 64                	push   $0x64
f0103d22:	e8 ce ff ff ff       	call   f0103cf5 <set_timer>

  /* Enable interrupt */
  irq_setmask_8259A(irq_mask_8259A & ~(1<<IRQ_TIMER));
f0103d27:	50                   	push   %eax
f0103d28:	50                   	push   %eax
f0103d29:	0f b7 05 3c 70 10 f0 	movzwl 0xf010703c,%eax
f0103d30:	25 fe ff 00 00       	and    $0xfffe,%eax
f0103d35:	50                   	push   %eax
f0103d36:	e8 dd db ff ff       	call   f0101918 <irq_setmask_8259A>

  /* Register trap handler */
  extern void TIM_ISR();
  register_handler( IRQ_OFFSET + IRQ_TIMER, &timer_handler, &TIM_ISR, 0, 0);
f0103d3b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
f0103d42:	6a 00                	push   $0x0
f0103d44:	68 3c 21 10 f0       	push   $0xf010213c
f0103d49:	68 90 3c 10 f0       	push   $0xf0103c90
f0103d4e:	6a 20                	push   $0x20
f0103d50:	e8 f0 e1 ff ff       	call   f0101f45 <register_handler>
}
f0103d55:	83 c4 2c             	add    $0x2c,%esp
f0103d58:	c3                   	ret    
f0103d59:	00 00                	add    %al,(%eax)
	...

f0103d5c <task_create>:
 *
 * 6. Return the pid of the newly created task.
 *
 */
int task_create()
{
f0103d5c:	57                   	push   %edi
            break;
        }
    
    }
    if(i==NR_TASKS)
        return -1;
f0103d5d:	b8 28 77 11 f0       	mov    $0xf0117728,%eax
 *
 * 6. Return the pid of the newly created task.
 *
 */
int task_create()
{
f0103d62:	56                   	push   %esi
f0103d63:	53                   	push   %ebx
	Task *ts = NULL;

	/* Find a free task structure */
    int i;
    for(i =0;i<NR_TASKS;i++)  
f0103d64:	31 db                	xor    %ebx,%ebx
    {
        if(tasks[i].state==TASK_FREE)
f0103d66:	83 38 00             	cmpl   $0x0,(%eax)
f0103d69:	75 13                	jne    f0103d7e <task_create+0x22>
        {
            ts = &(tasks[i]);
f0103d6b:	6b f3 58             	imul   $0x58,%ebx,%esi
            break;
        }
    
    }
    if(i==NR_TASKS)
f0103d6e:	83 fb 0a             	cmp    $0xa,%ebx
    int i;
    for(i =0;i<NR_TASKS;i++)  
    {
        if(tasks[i].state==TASK_FREE)
        {
            ts = &(tasks[i]);
f0103d71:	8d be d8 76 11 f0    	lea    -0xfee8928(%esi),%edi
            break;
        }
    
    }
    if(i==NR_TASKS)
f0103d77:	75 13                	jne    f0103d8c <task_create+0x30>
f0103d79:	e9 e4 00 00 00       	jmp    f0103e62 <task_create+0x106>
{
	Task *ts = NULL;

	/* Find a free task structure */
    int i;
    for(i =0;i<NR_TASKS;i++)  
f0103d7e:	43                   	inc    %ebx
f0103d7f:	83 c0 58             	add    $0x58,%eax
f0103d82:	83 fb 0a             	cmp    $0xa,%ebx
f0103d85:	75 df                	jne    f0103d66 <task_create+0xa>
f0103d87:	e9 d6 00 00 00       	jmp    f0103e62 <task_create+0x106>
    
    }
    if(i==NR_TASKS)
        return -1;
  /* Setup Page Directory and pages for kernel*/
  if (!(ts->pgdir = setupkvm()))
f0103d8c:	e8 76 fd ff ff       	call   f0103b07 <setupkvm>
f0103d91:	85 c0                	test   %eax,%eax
f0103d93:	89 86 2c 77 11 f0    	mov    %eax,-0xfee88d4(%esi)
f0103d99:	be 00 40 bf ee       	mov    $0xeebf4000,%esi
f0103d9e:	75 12                	jne    f0103db2 <task_create+0x56>
    panic("Not enough memory for per process page directory!\n");
f0103da0:	52                   	push   %edx
f0103da1:	68 37 65 10 f0       	push   $0xf0106537
f0103da6:	6a 75                	push   $0x75
f0103da8:	68 6a 65 10 f0       	push   $0xf010656a
f0103dad:	e8 36 fe ff ff       	call   f0103be8 <_panic>
  /* Setup User Stack */
    int j;
    struct PageInfo *u_stack;
    for(j = 0;j<USR_STACK_SIZE/PGSIZE;j++)
    {
        u_stack = page_alloc(ALLOC_ZERO);
f0103db2:	83 ec 0c             	sub    $0xc,%esp
f0103db5:	6a 01                	push   $0x1
f0103db7:	e8 29 e8 ff ff       	call   f01025e5 <page_alloc>
        if(u_stack==NULL)
f0103dbc:	83 c4 10             	add    $0x10,%esp
f0103dbf:	85 c0                	test   %eax,%eax
f0103dc1:	0f 84 9b 00 00 00    	je     f0103e62 <task_create+0x106>
            return -1;
        page_insert(ts->pgdir,u_stack,(void *)USTACKTOP-USR_STACK_SIZE+PGSIZE*j,PTE_W|PTE_U);
f0103dc7:	6a 06                	push   $0x6
f0103dc9:	56                   	push   %esi
f0103dca:	81 c6 00 10 00 00    	add    $0x1000,%esi
f0103dd0:	50                   	push   %eax
f0103dd1:	ff 77 54             	pushl  0x54(%edi)
f0103dd4:	e8 dc e9 ff ff       	call   f01027b5 <page_insert>
    panic("Not enough memory for per process page directory!\n");

  /* Setup User Stack */
    int j;
    struct PageInfo *u_stack;
    for(j = 0;j<USR_STACK_SIZE/PGSIZE;j++)
f0103dd9:	83 c4 10             	add    $0x10,%esp
f0103ddc:	81 fe 00 e0 bf ee    	cmp    $0xeebfe000,%esi
f0103de2:	75 ce                	jne    f0103db2 <task_create+0x56>
      p = page_alloc(ALLOC_ZERO);
      if (!p || page_insert(ts->pgdir, p, (void*)(USTACKTOP-USR_STACK_SIZE+j), PTE_W|PTE_U))
          panic("Not enough memory for user stack!\n");
  }*/
	/* Setup Trapframe */
	memset( &(ts->tf), 0, sizeof(ts->tf));
f0103de4:	6b f3 58             	imul   $0x58,%ebx,%esi
f0103de7:	50                   	push   %eax
f0103de8:	6a 44                	push   $0x44
f0103dea:	6a 00                	push   $0x0
f0103dec:	8d be d8 76 11 f0    	lea    -0xfee8928(%esi),%edi
f0103df2:	8d 47 08             	lea    0x8(%edi),%eax
f0103df5:	50                   	push   %eax
f0103df6:	e8 d4 c3 ff ff       	call   f01001cf <memset>

	ts->tf.tf_cs = GD_UT | 0x03;
	ts->tf.tf_ds = GD_UD | 0x03;
f0103dfb:	8d 86 f8 76 11 f0    	lea    -0xfee8908(%esi),%eax

	/* Setup task structure (task_id and parent_id) */
    ts->task_id = i;
    ts->remind_ticks =TIME_QUANT;
    ts->state = TASK_RUNNABLE;
    if(cur_task==NULL)
f0103e01:	83 c4 10             	add    $0x10,%esp
  }*/
	/* Setup Trapframe */
	memset( &(ts->tf), 0, sizeof(ts->tf));

	ts->tf.tf_cs = GD_UT | 0x03;
	ts->tf.tf_ds = GD_UD | 0x03;
f0103e04:	66 c7 40 0c 23 00    	movw   $0x23,0xc(%eax)
	ts->tf.tf_es = GD_UD | 0x03;
f0103e0a:	66 c7 40 08 23 00    	movw   $0x23,0x8(%eax)

	/* Setup task structure (task_id and parent_id) */
    ts->task_id = i;
    ts->remind_ticks =TIME_QUANT;
    ts->state = TASK_RUNNABLE;
    if(cur_task==NULL)
f0103e10:	a1 2c 4e 11 f0       	mov    0xf0114e2c,%eax
          panic("Not enough memory for user stack!\n");
  }*/
	/* Setup Trapframe */
	memset( &(ts->tf), 0, sizeof(ts->tf));

	ts->tf.tf_cs = GD_UT | 0x03;
f0103e15:	66 c7 86 14 77 11 f0 	movw   $0x1b,-0xfee88ec(%esi)
f0103e1c:	1b 00 
	ts->tf.tf_ds = GD_UD | 0x03;
	ts->tf.tf_es = GD_UD | 0x03;
	ts->tf.tf_ss = GD_UD | 0x03;
f0103e1e:	66 c7 86 20 77 11 f0 	movw   $0x23,-0xfee88e0(%esi)
f0103e25:	23 00 
	ts->tf.tf_esp = USTACKTOP-PGSIZE;
f0103e27:	c7 86 1c 77 11 f0 00 	movl   $0xeebfd000,-0xfee88e4(%esi)
f0103e2e:	d0 bf ee 

	/* Setup task structure (task_id and parent_id) */
    ts->task_id = i;
    ts->remind_ticks =TIME_QUANT;
    ts->state = TASK_RUNNABLE;
    if(cur_task==NULL)
f0103e31:	85 c0                	test   %eax,%eax
	ts->tf.tf_es = GD_UD | 0x03;
	ts->tf.tf_ss = GD_UD | 0x03;
	ts->tf.tf_esp = USTACKTOP-PGSIZE;

	/* Setup task structure (task_id and parent_id) */
    ts->task_id = i;
f0103e33:	89 9e d8 76 11 f0    	mov    %ebx,-0xfee8928(%esi)
    ts->remind_ticks =TIME_QUANT;
f0103e39:	c7 86 24 77 11 f0 64 	movl   $0x64,-0xfee88dc(%esi)
f0103e40:	00 00 00 
    ts->state = TASK_RUNNABLE;
f0103e43:	c7 47 50 01 00 00 00 	movl   $0x1,0x50(%edi)
    if(cur_task==NULL)
f0103e4a:	75 0c                	jne    f0103e58 <task_create+0xfc>
        ts->parent_id=0;
f0103e4c:	c7 86 dc 76 11 f0 00 	movl   $0x0,-0xfee8924(%esi)
f0103e53:	00 00 00 
f0103e56:	eb 0d                	jmp    f0103e65 <task_create+0x109>
    else
       ts->parent_id = cur_task->task_id;
f0103e58:	8b 00                	mov    (%eax),%eax
f0103e5a:	89 86 dc 76 11 f0    	mov    %eax,-0xfee8924(%esi)
f0103e60:	eb 03                	jmp    f0103e65 <task_create+0x109>
    struct PageInfo *u_stack;
    for(j = 0;j<USR_STACK_SIZE/PGSIZE;j++)
    {
        u_stack = page_alloc(ALLOC_ZERO);
        if(u_stack==NULL)
            return -1;
f0103e62:	83 cb ff             	or     $0xffffffff,%ebx
    if(cur_task==NULL)
        ts->parent_id=0;
    else
       ts->parent_id = cur_task->task_id;
    return i;
}
f0103e65:	89 d8                	mov    %ebx,%eax
f0103e67:	5b                   	pop    %ebx
f0103e68:	5e                   	pop    %esi
f0103e69:	5f                   	pop    %edi
f0103e6a:	c3                   	ret    

f0103e6b <sys_kill>:
    pgdir_remove(tasks[pid].pgdir);
    */
}

void sys_kill(int pid)
{
f0103e6b:	57                   	push   %edi
f0103e6c:	56                   	push   %esi
f0103e6d:	53                   	push   %ebx
	if (pid > 0 && pid < NR_TASKS)
f0103e6e:	8b 44 24 10          	mov    0x10(%esp),%eax
f0103e72:	48                   	dec    %eax
f0103e73:	83 f8 08             	cmp    $0x8,%eax
f0103e76:	0f 87 81 00 00 00    	ja     f0103efd <sys_kill+0x92>
	/* TODO: Lab 5
   * Remember to change the state of tasks
   * Free the memory
   * and invoke the scheduler for yield
   */
        cur_task->state = TASK_STOP;
f0103e7c:	a1 2c 4e 11 f0       	mov    0xf0114e2c,%eax
f0103e81:	c7 40 50 04 00 00 00 	movl   $0x4,0x50(%eax)
        task_free(cur_task->task_id);
f0103e88:	8b 38                	mov    (%eax),%edi
 * HINT: You can refer to page_remove, ptable_remove, and pgdir_remove
 */
static void task_free(int pid)
{
    
    lcr3(PADDR(kern_pgdir));
f0103e8a:	a1 c8 76 11 f0       	mov    0xf01176c8,%eax
/* -------------- Inline Functions --------------  */

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f0103e8f:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0103e94:	77 15                	ja     f0103eab <sys_kill+0x40>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0103e96:	50                   	push   %eax
f0103e97:	68 c2 54 10 f0       	push   $0xf01054c2
f0103e9c:	68 b3 00 00 00       	push   $0xb3
f0103ea1:	68 6a 65 10 f0       	push   $0xf010656a
f0103ea6:	e8 3d fd ff ff       	call   f0103be8 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0103eab:	05 00 00 00 10       	add    $0x10000000,%eax
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0103eb0:	0f 22 d8             	mov    %eax,%cr3
    int i;
    for(i = 0;i<USR_STACK_SIZE/PGSIZE;i++)
        page_remove(tasks[pid].pgdir,(void *)USTACKTOP-USR_STACK_SIZE+i*PGSIZE);
f0103eb3:	6b ff 58             	imul   $0x58,%edi,%edi
f0103eb6:	bb 00 40 bf ee       	mov    $0xeebf4000,%ebx
f0103ebb:	81 c7 dc 76 11 f0    	add    $0xf01176dc,%edi
f0103ec1:	56                   	push   %esi
f0103ec2:	56                   	push   %esi
f0103ec3:	53                   	push   %ebx
f0103ec4:	81 c3 00 10 00 00    	add    $0x1000,%ebx
f0103eca:	ff 77 50             	pushl  0x50(%edi)
f0103ecd:	8d 77 50             	lea    0x50(%edi),%esi
f0103ed0:	e8 a4 e8 ff ff       	call   f0102779 <page_remove>
static void task_free(int pid)
{
    
    lcr3(PADDR(kern_pgdir));
    int i;
    for(i = 0;i<USR_STACK_SIZE/PGSIZE;i++)
f0103ed5:	83 c4 10             	add    $0x10,%esp
f0103ed8:	81 fb 00 e0 bf ee    	cmp    $0xeebfe000,%ebx
f0103ede:	75 e1                	jne    f0103ec1 <sys_kill+0x56>
        page_remove(tasks[pid].pgdir,(void *)USTACKTOP-USR_STACK_SIZE+i*PGSIZE);
    ptable_remove(tasks[pid].pgdir);
f0103ee0:	83 ec 0c             	sub    $0xc,%esp
f0103ee3:	ff 36                	pushl  (%esi)
f0103ee5:	e8 48 fb ff ff       	call   f0103a32 <ptable_remove>

    pgdir_remove(tasks[pid].pgdir);
f0103eea:	59                   	pop    %ecx
f0103eeb:	ff 36                	pushl  (%esi)
f0103eed:	e8 77 fb ff ff       	call   f0103a69 <pgdir_remove>
   * Free the memory
   * and invoke the scheduler for yield
   */
        cur_task->state = TASK_STOP;
        task_free(cur_task->task_id);
        sched_yield();
f0103ef2:	83 c4 10             	add    $0x10,%esp
	}
}
f0103ef5:	5b                   	pop    %ebx
f0103ef6:	5e                   	pop    %esi
f0103ef7:	5f                   	pop    %edi
   * Free the memory
   * and invoke the scheduler for yield
   */
        cur_task->state = TASK_STOP;
        task_free(cur_task->task_id);
        sched_yield();
f0103ef8:	e9 e3 03 00 00       	jmp    f01042e0 <sched_yield>
	}
}
f0103efd:	5b                   	pop    %ebx
f0103efe:	5e                   	pop    %esi
f0103eff:	5f                   	pop    %edi
f0103f00:	c3                   	ret    

f0103f01 <sys_fork>:
 *
 * HINT: You should understand how system call return
 * it's return value.
 */
int sys_fork()
{
f0103f01:	55                   	push   %ebp
f0103f02:	57                   	push   %edi
f0103f03:	56                   	push   %esi
f0103f04:	53                   	push   %ebx
f0103f05:	83 ec 1c             	sub    $0x1c,%esp
  /* pid for newly created process */
  int pid,i;
  pid = task_create();
f0103f08:	e8 4f fe ff ff       	call   f0103d5c <task_create>
  uint32_t src_addr, dst_addr, *src, *dst;
  if(pid<0)
f0103f0d:	85 c0                	test   %eax,%eax
 */
int sys_fork()
{
  /* pid for newly created process */
  int pid,i;
  pid = task_create();
f0103f0f:	89 c3                	mov    %eax,%ebx
  uint32_t src_addr, dst_addr, *src, *dst;
  if(pid<0)
f0103f11:	0f 88 24 01 00 00    	js     f010403b <sys_fork+0x13a>
      return -1;
        if ((uint32_t)cur_task)
f0103f17:	8b 35 2c 4e 11 f0    	mov    0xf0114e2c,%esi
f0103f1d:	85 f6                	test   %esi,%esi
f0103f1f:	0f 84 19 01 00 00    	je     f010403e <sys_fork+0x13d>
        {
            tasks[pid].tf = cur_task->tf;
f0103f25:	6b c0 58             	imul   $0x58,%eax,%eax
f0103f28:	83 c6 08             	add    $0x8,%esi
f0103f2b:	b9 11 00 00 00       	mov    $0x11,%ecx
f0103f30:	8d b8 e0 76 11 f0    	lea    -0xfee8920(%eax),%edi
            for(i = 0; i < USR_STACK_SIZE/PGSIZE; i++)
            {
                src = pgdir_walk(cur_task->pgdir, (void *)(USTACKTOP-USR_STACK_SIZE+i*PGSIZE), 0);
                src_addr = PTE_ADDR(*src);
                dst = pgdir_walk(tasks[pid].pgdir, (void *)(USTACKTOP-USR_STACK_SIZE+i*PGSIZE), 0);
f0103f36:	05 dc 76 11 f0       	add    $0xf01176dc,%eax
  uint32_t src_addr, dst_addr, *src, *dst;
  if(pid<0)
      return -1;
        if ((uint32_t)cur_task)
        {
            tasks[pid].tf = cur_task->tf;
f0103f3b:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
f0103f3d:	bf 00 40 bf ee       	mov    $0xeebf4000,%edi
            for(i = 0; i < USR_STACK_SIZE/PGSIZE; i++)
            {
                src = pgdir_walk(cur_task->pgdir, (void *)(USTACKTOP-USR_STACK_SIZE+i*PGSIZE), 0);
                src_addr = PTE_ADDR(*src);
                dst = pgdir_walk(tasks[pid].pgdir, (void *)(USTACKTOP-USR_STACK_SIZE+i*PGSIZE), 0);
f0103f42:	89 44 24 0c          	mov    %eax,0xc(%esp)
        if ((uint32_t)cur_task)
        {
            tasks[pid].tf = cur_task->tf;
            for(i = 0; i < USR_STACK_SIZE/PGSIZE; i++)
            {
                src = pgdir_walk(cur_task->pgdir, (void *)(USTACKTOP-USR_STACK_SIZE+i*PGSIZE), 0);
f0103f46:	a1 2c 4e 11 f0       	mov    0xf0114e2c,%eax
f0103f4b:	52                   	push   %edx
f0103f4c:	6a 00                	push   $0x0
f0103f4e:	57                   	push   %edi
f0103f4f:	ff 70 54             	pushl  0x54(%eax)
f0103f52:	e8 28 e7 ff ff       	call   f010267f <pgdir_walk>
                src_addr = PTE_ADDR(*src);
                dst = pgdir_walk(tasks[pid].pgdir, (void *)(USTACKTOP-USR_STACK_SIZE+i*PGSIZE), 0);
f0103f57:	83 c4 0c             	add    $0xc,%esp
        {
            tasks[pid].tf = cur_task->tf;
            for(i = 0; i < USR_STACK_SIZE/PGSIZE; i++)
            {
                src = pgdir_walk(cur_task->pgdir, (void *)(USTACKTOP-USR_STACK_SIZE+i*PGSIZE), 0);
                src_addr = PTE_ADDR(*src);
f0103f5a:	8b 30                	mov    (%eax),%esi
                dst = pgdir_walk(tasks[pid].pgdir, (void *)(USTACKTOP-USR_STACK_SIZE+i*PGSIZE), 0);
f0103f5c:	6a 00                	push   $0x0
f0103f5e:	57                   	push   %edi
f0103f5f:	8b 44 24 18          	mov    0x18(%esp),%eax
f0103f63:	8b 6c 24 18          	mov    0x18(%esp),%ebp
        {
            tasks[pid].tf = cur_task->tf;
            for(i = 0; i < USR_STACK_SIZE/PGSIZE; i++)
            {
                src = pgdir_walk(cur_task->pgdir, (void *)(USTACKTOP-USR_STACK_SIZE+i*PGSIZE), 0);
                src_addr = PTE_ADDR(*src);
f0103f67:	81 e6 00 f0 ff ff    	and    $0xfffff000,%esi
                dst = pgdir_walk(tasks[pid].pgdir, (void *)(USTACKTOP-USR_STACK_SIZE+i*PGSIZE), 0);
f0103f6d:	ff 70 50             	pushl  0x50(%eax)
f0103f70:	83 c5 50             	add    $0x50,%ebp
f0103f73:	e8 07 e7 ff ff       	call   f010267f <pgdir_walk>
}

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103f78:	89 f1                	mov    %esi,%ecx
f0103f7a:	83 c4 10             	add    $0x10,%esp
f0103f7d:	c1 e9 0c             	shr    $0xc,%ecx
                dst_addr = PTE_ADDR(*dst);
f0103f80:	8b 10                	mov    (%eax),%edx
f0103f82:	a1 c4 76 11 f0       	mov    0xf01176c4,%eax
f0103f87:	39 c1                	cmp    %eax,%ecx
f0103f89:	72 03                	jb     f0103f8e <sys_fork+0x8d>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103f8b:	56                   	push   %esi
f0103f8c:	eb 10                	jmp    f0103f9e <sys_fork+0x9d>
f0103f8e:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
}

static inline void*
_kaddr(const char *file, int line, physaddr_t pa)
{
	if (PGNUM(pa) >= npages)
f0103f94:	89 d1                	mov    %edx,%ecx
f0103f96:	c1 e9 0c             	shr    $0xc,%ecx
f0103f99:	39 c1                	cmp    %eax,%ecx
f0103f9b:	72 15                	jb     f0103fb2 <sys_fork+0xb1>
		_panic(file, line, "KADDR called with invalid pa %08lx", pa);
f0103f9d:	52                   	push   %edx
f0103f9e:	68 9c 5a 10 f0       	push   $0xf0105a9c
f0103fa3:	68 fc 00 00 00       	push   $0xfc
f0103fa8:	68 6a 65 10 f0       	push   $0xf010656a
f0103fad:	e8 36 fc ff ff       	call   f0103be8 <_panic>
                memcpy(KADDR(dst_addr), KADDR(src_addr), PGSIZE);
f0103fb2:	50                   	push   %eax
	return (void *)(pa + KERNBASE);
f0103fb3:	81 ee 00 00 00 10    	sub    $0x10000000,%esi
f0103fb9:	68 00 10 00 00       	push   $0x1000
f0103fbe:	81 ea 00 00 00 10    	sub    $0x10000000,%edx
f0103fc4:	56                   	push   %esi
f0103fc5:	81 c7 00 10 00 00    	add    $0x1000,%edi
f0103fcb:	52                   	push   %edx
f0103fcc:	e8 d8 c2 ff ff       	call   f01002a9 <memcpy>
  if(pid<0)
      return -1;
        if ((uint32_t)cur_task)
        {
            tasks[pid].tf = cur_task->tf;
            for(i = 0; i < USR_STACK_SIZE/PGSIZE; i++)
f0103fd1:	83 c4 10             	add    $0x10,%esp
f0103fd4:	81 ff 00 e0 bf ee    	cmp    $0xeebfe000,%edi
f0103fda:	0f 85 66 ff ff ff    	jne    f0103f46 <sys_fork+0x45>
                dst_addr = PTE_ADDR(*dst);
                memcpy(KADDR(dst_addr), KADDR(src_addr), PGSIZE);
            }
            
        /* Step 4: All user program use the same code for now */
        setupvm(tasks[pid].pgdir, (uint32_t)UTEXT_start, UTEXT_SZ);
f0103fe0:	57                   	push   %edi
f0103fe1:	ff 35 54 7a 11 f0    	pushl  0xf0117a54
f0103fe7:	68 00 00 10 f0       	push   $0xf0100000
f0103fec:	ff 75 00             	pushl  0x0(%ebp)
f0103fef:	e8 9f fa ff ff       	call   f0103a93 <setupvm>
        setupvm(tasks[pid].pgdir, (uint32_t)UDATA_start, UDATA_SZ);
f0103ff4:	83 c4 0c             	add    $0xc,%esp
f0103ff7:	ff 35 50 7a 11 f0    	pushl  0xf0117a50
f0103ffd:	68 00 70 10 f0       	push   $0xf0107000
f0104002:	ff 75 00             	pushl  0x0(%ebp)
f0104005:	e8 89 fa ff ff       	call   f0103a93 <setupvm>
        setupvm(tasks[pid].pgdir, (uint32_t)UBSS_start, UBSS_SZ);
f010400a:	83 c4 0c             	add    $0xc,%esp
f010400d:	ff 35 48 7a 11 f0    	pushl  0xf0117a48
f0104013:	68 00 b0 10 f0       	push   $0xf010b000
f0104018:	ff 75 00             	pushl  0x0(%ebp)
f010401b:	e8 73 fa ff ff       	call   f0103a93 <setupvm>
        setupvm(tasks[pid].pgdir, (uint32_t)URODATA_start, URODATA_SZ);
f0104020:	83 c4 0c             	add    $0xc,%esp
f0104023:	ff 35 4c 7a 11 f0    	pushl  0xf0117a4c
f0104029:	68 00 50 10 f0       	push   $0xf0105000
f010402e:	ff 75 00             	pushl  0x0(%ebp)
f0104031:	e8 5d fa ff ff       	call   f0103a93 <setupvm>
f0104036:	83 c4 10             	add    $0x10,%esp
f0104039:	eb 03                	jmp    f010403e <sys_fork+0x13d>
  /* pid for newly created process */
  int pid,i;
  pid = task_create();
  uint32_t src_addr, dst_addr, *src, *dst;
  if(pid<0)
      return -1;
f010403b:	83 cb ff             	or     $0xffffffff,%ebx

        //cur_task->tf.tf_regs.reg_eax = pid;
        //tasks[pid].tf.tf_regs.reg_eax = 0;
        }
    return pid;
}
f010403e:	83 c4 1c             	add    $0x1c,%esp
f0104041:	89 d8                	mov    %ebx,%eax
f0104043:	5b                   	pop    %ebx
f0104044:	5e                   	pop    %esi
f0104045:	5f                   	pop    %edi
f0104046:	5d                   	pop    %ebp
f0104047:	c3                   	ret    

f0104048 <task_init>:
 */
void task_init()
{
  extern int user_entry();
	int i;
  UTEXT_SZ = (uint32_t)(UTEXT_end - UTEXT_start);
f0104048:	b8 f8 17 10 f0       	mov    $0xf01017f8,%eax
/* TODO: Lab5
 * We've done the initialization for you,
 * please make sure you understand the code.
 */
void task_init()
{
f010404d:	53                   	push   %ebx
  extern int user_entry();
	int i;
  UTEXT_SZ = (uint32_t)(UTEXT_end - UTEXT_start);
f010404e:	2d 00 00 10 f0       	sub    $0xf0100000,%eax
/* TODO: Lab5
 * We've done the initialization for you,
 * please make sure you understand the code.
 */
void task_init()
{
f0104053:	83 ec 08             	sub    $0x8,%esp
  extern int user_entry();
	int i;
  UTEXT_SZ = (uint32_t)(UTEXT_end - UTEXT_start);
  UDATA_SZ = (uint32_t)(UDATA_end - UDATA_start);
  UBSS_SZ = (uint32_t)(UBSS_end - UBSS_start);
  URODATA_SZ = (uint32_t)(URODATA_end - URODATA_start);
f0104056:	bb d8 76 11 f0       	mov    $0xf01176d8,%ebx
 */
void task_init()
{
  extern int user_entry();
	int i;
  UTEXT_SZ = (uint32_t)(UTEXT_end - UTEXT_start);
f010405b:	a3 54 7a 11 f0       	mov    %eax,0xf0117a54
  UDATA_SZ = (uint32_t)(UDATA_end - UDATA_start);
f0104060:	b8 3c 70 10 f0       	mov    $0xf010703c,%eax
f0104065:	2d 00 70 10 f0       	sub    $0xf0107000,%eax
f010406a:	a3 50 7a 11 f0       	mov    %eax,0xf0117a50
  UBSS_SZ = (uint32_t)(UBSS_end - UBSS_start);
f010406f:	b8 58 7a 11 f0       	mov    $0xf0117a58,%eax
f0104074:	2d 00 b0 10 f0       	sub    $0xf010b000,%eax
f0104079:	a3 48 7a 11 f0       	mov    %eax,0xf0117a48
  URODATA_SZ = (uint32_t)(URODATA_end - URODATA_start);
f010407e:	b8 88 51 10 f0       	mov    $0xf0105188,%eax
f0104083:	2d 00 50 10 f0       	sub    $0xf0105000,%eax
f0104088:	a3 4c 7a 11 f0       	mov    %eax,0xf0117a4c

	/* Initial task sturcture */
	for (i = 0; i < NR_TASKS; i++)
	{
		memset(&(tasks[i]), 0, sizeof(Task));
f010408d:	50                   	push   %eax
f010408e:	6a 58                	push   $0x58
f0104090:	6a 00                	push   $0x0
f0104092:	53                   	push   %ebx
f0104093:	e8 37 c1 ff ff       	call   f01001cf <memset>
  UDATA_SZ = (uint32_t)(UDATA_end - UDATA_start);
  UBSS_SZ = (uint32_t)(UBSS_end - UBSS_start);
  URODATA_SZ = (uint32_t)(URODATA_end - URODATA_start);

	/* Initial task sturcture */
	for (i = 0; i < NR_TASKS; i++)
f0104098:	83 c4 10             	add    $0x10,%esp
	{
		memset(&(tasks[i]), 0, sizeof(Task));
		tasks[i].state = TASK_FREE;
f010409b:	c7 43 50 00 00 00 00 	movl   $0x0,0x50(%ebx)
f01040a2:	83 c3 58             	add    $0x58,%ebx
  UDATA_SZ = (uint32_t)(UDATA_end - UDATA_start);
  UBSS_SZ = (uint32_t)(UBSS_end - UBSS_start);
  URODATA_SZ = (uint32_t)(URODATA_end - URODATA_start);

	/* Initial task sturcture */
	for (i = 0; i < NR_TASKS; i++)
f01040a5:	81 fb 48 7a 11 f0    	cmp    $0xf0117a48,%ebx
f01040ab:	75 e0                	jne    f010408d <task_init+0x45>
		tasks[i].state = TASK_FREE;

	}
	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	memset(&(tss), 0, sizeof(tss));
f01040ad:	51                   	push   %ecx
f01040ae:	6a 68                	push   $0x68
f01040b0:	6a 00                	push   $0x0
f01040b2:	68 30 4e 11 f0       	push   $0xf0114e30
f01040b7:	e8 13 c1 ff ff       	call   f01001cf <memset>
	// fs and gs stay in user data segment
	tss.ts_fs = GD_UD | 0x03;
	tss.ts_gs = GD_UD | 0x03;

	/* Setup TSS in GDT */
	gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t)(&tss), sizeof(struct tss_struct), 0);
f01040bc:	b8 30 4e 11 f0       	mov    $0xf0114e30,%eax
f01040c1:	89 c2                	mov    %eax,%edx
f01040c3:	c1 ea 10             	shr    $0x10,%edx
f01040c6:	66 a3 2a a0 10 f0    	mov    %ax,0xf010a02a
f01040cc:	c1 e8 18             	shr    $0x18,%eax
f01040cf:	88 15 2c a0 10 f0    	mov    %dl,0xf010a02c

	}
	// Setup a TSS so that we get the right stack
	// when we trap to the kernel.
	memset(&(tss), 0, sizeof(tss));
	tss.ts_esp0 = (uint32_t)bootstack + KSTKSIZE;
f01040d5:	c7 05 34 4e 11 f0 00 	movl   $0xf0114000,0xf0114e34
f01040dc:	40 11 f0 
	tss.ts_ss0 = GD_KD;
f01040df:	66 c7 05 38 4e 11 f0 	movw   $0x10,0xf0114e38
f01040e6:	10 00 

	// fs and gs stay in user data segment
	tss.ts_fs = GD_UD | 0x03;
f01040e8:	66 c7 05 88 4e 11 f0 	movw   $0x23,0xf0114e88
f01040ef:	23 00 
	tss.ts_gs = GD_UD | 0x03;
f01040f1:	66 c7 05 8c 4e 11 f0 	movw   $0x23,0xf0114e8c
f01040f8:	23 00 

	/* Setup TSS in GDT */
	gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t)(&tss), sizeof(struct tss_struct), 0);
f01040fa:	66 c7 05 28 a0 10 f0 	movw   $0x68,0xf010a028
f0104101:	68 00 
f0104103:	c6 05 2e a0 10 f0 40 	movb   $0x40,0xf010a02e
f010410a:	a2 2f a0 10 f0       	mov    %al,0xf010a02f
	gdt[GD_TSS0 >> 3].sd_s = 0;
f010410f:	c6 05 2d a0 10 f0 89 	movb   $0x89,0xf010a02d

	/* Setup first task */
	i = task_create();
f0104116:	e8 41 fc ff ff       	call   f0103d5c <task_create>
	cur_task = &(tasks[i]);

  /* For user program */
  setupvm(cur_task->pgdir, (uint32_t)UTEXT_start, UTEXT_SZ);
f010411b:	83 c4 0c             	add    $0xc,%esp
f010411e:	ff 35 54 7a 11 f0    	pushl  0xf0117a54
f0104124:	68 00 00 10 f0       	push   $0xf0100000
	gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t)(&tss), sizeof(struct tss_struct), 0);
	gdt[GD_TSS0 >> 3].sd_s = 0;

	/* Setup first task */
	i = task_create();
	cur_task = &(tasks[i]);
f0104129:	6b c0 58             	imul   $0x58,%eax,%eax

  /* For user program */
  setupvm(cur_task->pgdir, (uint32_t)UTEXT_start, UTEXT_SZ);
f010412c:	ff b0 2c 77 11 f0    	pushl  -0xfee88d4(%eax)
	gdt[GD_TSS0 >> 3] = SEG16(STS_T32A, (uint32_t)(&tss), sizeof(struct tss_struct), 0);
	gdt[GD_TSS0 >> 3].sd_s = 0;

	/* Setup first task */
	i = task_create();
	cur_task = &(tasks[i]);
f0104132:	8d 90 d8 76 11 f0    	lea    -0xfee8928(%eax),%edx
f0104138:	89 15 2c 4e 11 f0    	mov    %edx,0xf0114e2c

  /* For user program */
  setupvm(cur_task->pgdir, (uint32_t)UTEXT_start, UTEXT_SZ);
f010413e:	e8 50 f9 ff ff       	call   f0103a93 <setupvm>
  setupvm(cur_task->pgdir, (uint32_t)UDATA_start, UDATA_SZ);
f0104143:	83 c4 0c             	add    $0xc,%esp
f0104146:	a1 2c 4e 11 f0       	mov    0xf0114e2c,%eax
f010414b:	ff 35 50 7a 11 f0    	pushl  0xf0117a50
f0104151:	68 00 70 10 f0       	push   $0xf0107000
f0104156:	ff 70 54             	pushl  0x54(%eax)
f0104159:	e8 35 f9 ff ff       	call   f0103a93 <setupvm>
  setupvm(cur_task->pgdir, (uint32_t)UBSS_start, UBSS_SZ);
f010415e:	83 c4 0c             	add    $0xc,%esp
f0104161:	a1 2c 4e 11 f0       	mov    0xf0114e2c,%eax
f0104166:	ff 35 48 7a 11 f0    	pushl  0xf0117a48
f010416c:	68 00 b0 10 f0       	push   $0xf010b000
f0104171:	ff 70 54             	pushl  0x54(%eax)
f0104174:	e8 1a f9 ff ff       	call   f0103a93 <setupvm>
  setupvm(cur_task->pgdir, (uint32_t)URODATA_start, URODATA_SZ);
f0104179:	83 c4 0c             	add    $0xc,%esp
f010417c:	a1 2c 4e 11 f0       	mov    0xf0114e2c,%eax
f0104181:	ff 35 4c 7a 11 f0    	pushl  0xf0117a4c
f0104187:	68 00 50 10 f0       	push   $0xf0105000
f010418c:	ff 70 54             	pushl  0x54(%eax)
f010418f:	e8 ff f8 ff ff       	call   f0103a93 <setupvm>
  cur_task->tf.tf_eip = (uint32_t)user_entry;
f0104194:	a1 2c 4e 11 f0       	mov    0xf0114e2c,%eax
}

static __inline void
lgdt(void *p)
{
	__asm __volatile("lgdt (%0)" : : "r" (p));
f0104199:	ba 30 a0 10 f0       	mov    $0xf010a030,%edx
f010419e:	c7 40 38 b8 14 10 f0 	movl   $0xf01014b8,0x38(%eax)
f01041a5:	0f 01 12             	lgdtl  (%edx)
}

static __inline void
lldt(uint16_t sel)
{
	__asm __volatile("lldt %0" : : "r" (sel));
f01041a8:	31 d2                	xor    %edx,%edx
f01041aa:	0f 00 d2             	lldt   %dx
}

static __inline void
ltr(uint16_t sel)
{
	__asm __volatile("ltr %0" : : "r" (sel));
f01041ad:	b2 28                	mov    $0x28,%dl
f01041af:	0f 00 da             	ltr    %dx
	lldt(0);

	// Load the TSS selector 
	ltr(GD_TSS0);

	cur_task->state = TASK_RUNNING;
f01041b2:	c7 40 50 02 00 00 00 	movl   $0x2,0x50(%eax)
	
}
f01041b9:	83 c4 18             	add    $0x18,%esp
f01041bc:	5b                   	pop    %ebx
f01041bd:	c3                   	ret    
	...

f01041c0 <do_puts>:
#include <kernel/syscall.h>
#include <kernel/trap.h>
#include <inc/stdio.h>

void do_puts(char *str, uint32_t len)
{
f01041c0:	57                   	push   %edi
f01041c1:	56                   	push   %esi
f01041c2:	53                   	push   %ebx
	uint32_t i;
	for (i = 0; i < len; i++)
f01041c3:	31 db                	xor    %ebx,%ebx
#include <kernel/syscall.h>
#include <kernel/trap.h>
#include <inc/stdio.h>

void do_puts(char *str, uint32_t len)
{
f01041c5:	8b 7c 24 10          	mov    0x10(%esp),%edi
f01041c9:	8b 74 24 14          	mov    0x14(%esp),%esi
	uint32_t i;
	for (i = 0; i < len; i++)
f01041cd:	eb 11                	jmp    f01041e0 <do_puts+0x20>
	{
		k_putch(str[i]);
f01041cf:	0f b6 04 1f          	movzbl (%edi,%ebx,1),%eax
f01041d3:	83 ec 0c             	sub    $0xc,%esp
#include <inc/stdio.h>

void do_puts(char *str, uint32_t len)
{
	uint32_t i;
	for (i = 0; i < len; i++)
f01041d6:	43                   	inc    %ebx
	{
		k_putch(str[i]);
f01041d7:	50                   	push   %eax
f01041d8:	e8 42 da ff ff       	call   f0101c1f <k_putch>
#include <inc/stdio.h>

void do_puts(char *str, uint32_t len)
{
	uint32_t i;
	for (i = 0; i < len; i++)
f01041dd:	83 c4 10             	add    $0x10,%esp
f01041e0:	39 f3                	cmp    %esi,%ebx
f01041e2:	72 eb                	jb     f01041cf <do_puts+0xf>
	{
		k_putch(str[i]);
	}
}
f01041e4:	5b                   	pop    %ebx
f01041e5:	5e                   	pop    %esi
f01041e6:	5f                   	pop    %edi
f01041e7:	c3                   	ret    

f01041e8 <do_getc>:

int32_t do_getc()
{
f01041e8:	83 ec 0c             	sub    $0xc,%esp
	return k_getc();
}
f01041eb:	83 c4 0c             	add    $0xc,%esp
	}
}

int32_t do_getc()
{
	return k_getc();
f01041ee:	e9 2d d9 ff ff       	jmp    f0101b20 <k_getc>

f01041f3 <do_syscall>:
}

int32_t do_syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f01041f3:	53                   	push   %ebx
	int32_t retVal = -1;
f01041f4:	83 c8 ff             	or     $0xffffffff,%eax
{
	return k_getc();
}

int32_t do_syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
f01041f7:	83 ec 08             	sub    $0x8,%esp
f01041fa:	8b 5c 24 10          	mov    0x10(%esp),%ebx
f01041fe:	8b 54 24 14          	mov    0x14(%esp),%edx
f0104202:	8b 4c 24 18          	mov    0x18(%esp),%ecx
	int32_t retVal = -1;
	extern Task *cur_task;

	switch (syscallno)
f0104206:	83 fb 0a             	cmp    $0xa,%ebx
f0104209:	0f 87 87 00 00 00    	ja     f0104296 <do_syscall+0xa3>
f010420f:	ff 24 9d 78 65 10 f0 	jmp    *-0xfef9a88(,%ebx,4)
    retVal = 0;
    break;

	}
	return retVal;
}
f0104216:	83 c4 08             	add    $0x8,%esp
f0104219:	5b                   	pop    %ebx
	{
	case SYS_fork:
		/* TODO: Lab 5
     * You can reference kernel/task.c, kernel/task.h
     */
        retVal =sys_fork();
f010421a:	e9 e2 fc ff ff       	jmp    f0103f01 <sys_fork>
    retVal = 0;
    break;

	}
	return retVal;
}
f010421f:	83 c4 08             	add    $0x8,%esp
f0104222:	5b                   	pop    %ebx
	}
}

int32_t do_getc()
{
	return k_getc();
f0104223:	e9 f8 d8 ff ff       	jmp    f0101b20 <k_getc>
	case SYS_getc:
		retVal = do_getc();
		break;

	case SYS_puts:
		do_puts((char*)a1, a2);
f0104228:	53                   	push   %ebx
f0104229:	53                   	push   %ebx
f010422a:	51                   	push   %ecx
f010422b:	52                   	push   %edx
f010422c:	e8 8f ff ff ff       	call   f01041c0 <do_puts>
f0104231:	eb 57                	jmp    f010428a <do_syscall+0x97>

	case SYS_getpid:
		/* TODO: Lab 5
     * Get current task's pid
     */
        retVal = cur_task->task_id;
f0104233:	a1 2c 4e 11 f0       	mov    0xf0114e2c,%eax
f0104238:	8b 00                	mov    (%eax),%eax
		break;
f010423a:	eb 5a                	jmp    f0104296 <do_syscall+0xa3>
	case SYS_sleep:
		/* TODO: Lab 5
     * Yield this task
     * You can reference kernel/sched.c for yielding the task
     */ 
        cur_task->remind_ticks = a1;
f010423c:	a1 2c 4e 11 f0       	mov    0xf0114e2c,%eax
f0104241:	89 50 4c             	mov    %edx,0x4c(%eax)
        cur_task->state = TASK_SLEEP;
f0104244:	c7 40 50 03 00 00 00 	movl   $0x3,0x50(%eax)
        sched_yield();
f010424b:	e8 90 00 00 00       	call   f01042e0 <sched_yield>
	return k_getc();
}

int32_t do_syscall(uint32_t syscallno, uint32_t a1, uint32_t a2, uint32_t a3, uint32_t a4, uint32_t a5)
{
	int32_t retVal = -1;
f0104250:	83 c8 ff             	or     $0xffffffff,%eax
     * You can reference kernel/sched.c for yielding the task
     */ 
        cur_task->remind_ticks = a1;
        cur_task->state = TASK_SLEEP;
        sched_yield();
		break;
f0104253:	eb 41                	jmp    f0104296 <do_syscall+0xa3>
	case SYS_kill:
		/* TODO: Lab 5
     * Kill specific task
     * You can reference kernel/task.c, kernel/task.h
     */
        sys_kill(a1);
f0104255:	83 ec 0c             	sub    $0xc,%esp
f0104258:	52                   	push   %edx
f0104259:	e8 0d fc ff ff       	call   f0103e6b <sys_kill>
f010425e:	eb 2a                	jmp    f010428a <do_syscall+0x97>
    retVal = 0;
    break;

	}
	return retVal;
}
f0104260:	83 c4 08             	add    $0x8,%esp
f0104263:	5b                   	pop    %ebx

  case SYS_get_num_free_page:
		/* TODO: Lab 5
     * You can reference kernel/mem.c
     */
    retVal = sys_get_num_free_page();
f0104264:	e9 41 f9 ff ff       	jmp    f0103baa <sys_get_num_free_page>
    retVal = 0;
    break;

	}
	return retVal;
}
f0104269:	83 c4 08             	add    $0x8,%esp
f010426c:	5b                   	pop    %ebx

  case SYS_get_num_used_page:
		/* TODO: Lab 5
     * You can reference kernel/mem.c
     */
    retVal = sys_get_num_used_page();
f010426d:	e9 60 f9 ff ff       	jmp    f0103bd2 <sys_get_num_used_page>
    retVal = 0;
    break;

	}
	return retVal;
}
f0104272:	83 c4 08             	add    $0x8,%esp
f0104275:	5b                   	pop    %ebx

  case SYS_get_ticks:
		/* TODO: Lab 5
     * You can reference kernel/timer.c
     */
    retVal = sys_get_ticks();
f0104276:	e9 9c fa ff ff       	jmp    f0103d17 <sys_get_ticks>

  case SYS_settextcolor:
		/* TODO: Lab 5
     * You can reference kernel/screen.c
     */
    sys_settextcolor((unsigned char) a1,(unsigned char) a2);
f010427b:	50                   	push   %eax
f010427c:	0f b6 c9             	movzbl %cl,%ecx
f010427f:	50                   	push   %eax
f0104280:	0f b6 d2             	movzbl %dl,%edx
f0104283:	51                   	push   %ecx
f0104284:	52                   	push   %edx
f0104285:	e8 8b da ff ff       	call   f0101d15 <sys_settextcolor>
    retVal = 0;
    break;
f010428a:	83 c4 10             	add    $0x10,%esp
f010428d:	eb 05                	jmp    f0104294 <do_syscall+0xa1>

  case SYS_cls:
		/* TODO: Lab 5
     * You can reference kernel/screen.c
     */
    sys_cls();
f010428f:	e8 35 d9 ff ff       	call   f0101bc9 <sys_cls>
    retVal = 0;
f0104294:	31 c0                	xor    %eax,%eax
    break;

	}
	return retVal;
}
f0104296:	83 c4 08             	add    $0x8,%esp
f0104299:	5b                   	pop    %ebx
f010429a:	c3                   	ret    

f010429b <syscall_handler>:

static void syscall_handler(struct Trapframe *tf)
{
f010429b:	53                   	push   %ebx
f010429c:	83 ec 10             	sub    $0x10,%esp
f010429f:	8b 5c 24 18          	mov    0x18(%esp),%ebx
	/* TODO: Lab5
   * call do_syscall
   * Please remember to fill in the return value
   * HINT: You have to know where to put the return value
   */int32_t val;
    val = do_syscall(tf->tf_regs.reg_eax, tf->tf_regs.reg_edx, tf->tf_regs.reg_ecx, tf->tf_regs.reg_ebx, tf->tf_regs.reg_edi, tf->tf_regs.reg_esi); 
f01042a3:	ff 73 04             	pushl  0x4(%ebx)
f01042a6:	ff 33                	pushl  (%ebx)
f01042a8:	ff 73 10             	pushl  0x10(%ebx)
f01042ab:	ff 73 18             	pushl  0x18(%ebx)
f01042ae:	ff 73 14             	pushl  0x14(%ebx)
f01042b1:	ff 73 1c             	pushl  0x1c(%ebx)
f01042b4:	e8 3a ff ff ff       	call   f01041f3 <do_syscall>
    tf->tf_regs.reg_eax = val;
f01042b9:	89 43 1c             	mov    %eax,0x1c(%ebx)


}
f01042bc:	83 c4 28             	add    $0x28,%esp
f01042bf:	5b                   	pop    %ebx
f01042c0:	c3                   	ret    

f01042c1 <syscall_init>:

void syscall_init()
{
f01042c1:	83 ec 18             	sub    $0x18,%esp
  /* TODO: Lab5
   * Please set gate of system call into IDT
   * You can leverage the API register_handler in kernel/trap.c
   */
    extern void do_sys();
    register_handler( T_SYSCALL, &syscall_handler, &do_sys, 1, 3);
f01042c4:	6a 03                	push   $0x3
f01042c6:	6a 01                	push   $0x1
f01042c8:	68 42 21 10 f0       	push   $0xf0102142
f01042cd:	68 9b 42 10 f0       	push   $0xf010429b
f01042d2:	6a 30                	push   $0x30
f01042d4:	e8 6c dc ff ff       	call   f0101f45 <register_handler>

}
f01042d9:	83 c4 2c             	add    $0x2c,%esp
f01042dc:	c3                   	ret    
f01042dd:	00 00                	add    %al,(%eax)
	...

f01042e0 <sched_yield>:
*    Please make sure you understand the mechanism.
*/
static int i=1;
void sched();
void sched_yield(void)
{   
f01042e0:	55                   	push   %ebp
	extern Task *cur_task;
    volatile int next;
    while(1){
        next = (cur_task->task_id + i++)%NR_TASKS;
        if(i==NR_TASKS)
            i = 0;
f01042e1:	31 ed                	xor    %ebp,%ebp
*    Please make sure you understand the mechanism.
*/
static int i=1;
void sched();
void sched_yield(void)
{   
f01042e3:	57                   	push   %edi
	extern Task tasks[];
	extern Task *cur_task;
    volatile int next;
    while(1){
        next = (cur_task->task_id + i++)%NR_TASKS;
f01042e4:	bf 0a 00 00 00       	mov    $0xa,%edi
*    Please make sure you understand the mechanism.
*/
static int i=1;
void sched();
void sched_yield(void)
{   
f01042e9:	56                   	push   %esi
f01042ea:	53                   	push   %ebx
f01042eb:	83 ec 1c             	sub    $0x1c,%esp
	extern Task tasks[];
	extern Task *cur_task;
    volatile int next;
    while(1){
        next = (cur_task->task_id + i++)%NR_TASKS;
f01042ee:	8b 35 2c 4e 11 f0    	mov    0xf0114e2c,%esi
f01042f4:	8b 0d 38 a0 10 f0    	mov    0xf010a038,%ecx
f01042fa:	8b 1e                	mov    (%esi),%ebx
f01042fc:	8d 04 19             	lea    (%ecx,%ebx,1),%eax
f01042ff:	41                   	inc    %ecx
f0104300:	99                   	cltd   
f0104301:	f7 ff                	idiv   %edi
        if(i==NR_TASKS)
            i = 0;
f0104303:	83 f9 0a             	cmp    $0xa,%ecx
f0104306:	0f 44 cd             	cmove  %ebp,%ecx
{   
	extern Task tasks[];
	extern Task *cur_task;
    volatile int next;
    while(1){
        next = (cur_task->task_id + i++)%NR_TASKS;
f0104309:	89 54 24 0c          	mov    %edx,0xc(%esp)
        if(i==NR_TASKS)
            i = 0;
        if(next == cur_task->task_id)
f010430d:	8b 44 24 0c          	mov    0xc(%esp),%eax
f0104311:	39 d8                	cmp    %ebx,%eax
f0104313:	75 06                	jne    f010431b <sched_yield+0x3b>
            if(cur_task->state==TASK_RUNNING)
f0104315:	83 7e 50 02          	cmpl   $0x2,0x50(%esi)
f0104319:	74 75                	je     f0104390 <sched_yield+0xb0>
            break; 
        if(tasks[next].state==TASK_RUNNABLE)
f010431b:	8b 44 24 0c          	mov    0xc(%esp),%eax
f010431f:	6b c0 58             	imul   $0x58,%eax,%eax
f0104322:	83 b8 28 77 11 f0 01 	cmpl   $0x1,-0xfee88d8(%eax)
f0104329:	75 d1                	jne    f01042fc <sched_yield+0x1c>
        {
            cur_task =&(tasks[next]);
f010432b:	8b 44 24 0c          	mov    0xc(%esp),%eax
        if(i==NR_TASKS)
            i = 0;
        if(next == cur_task->task_id)
            if(cur_task->state==TASK_RUNNING)
            break; 
        if(tasks[next].state==TASK_RUNNABLE)
f010432f:	89 0d 38 a0 10 f0    	mov    %ecx,0xf010a038
        {
            cur_task =&(tasks[next]);
f0104335:	6b c0 58             	imul   $0x58,%eax,%eax
f0104338:	8d 90 d8 76 11 f0    	lea    -0xfee8928(%eax),%edx
            cur_task->state = TASK_RUNNING;
            cur_task->remind_ticks = TIME_QUANT;
f010433e:	c7 80 24 77 11 f0 64 	movl   $0x64,-0xfee88dc(%eax)
f0104345:	00 00 00 
            lcr3(PADDR(cur_task->pgdir));
f0104348:	8b 80 2c 77 11 f0    	mov    -0xfee88d4(%eax),%eax
        if(next == cur_task->task_id)
            if(cur_task->state==TASK_RUNNING)
            break; 
        if(tasks[next].state==TASK_RUNNABLE)
        {
            cur_task =&(tasks[next]);
f010434e:	89 15 2c 4e 11 f0    	mov    %edx,0xf0114e2c
            cur_task->state = TASK_RUNNING;
f0104354:	c7 42 50 02 00 00 00 	movl   $0x2,0x50(%edx)
/* -------------- Inline Functions --------------  */

static inline physaddr_t
_paddr(const char *file, int line, void *kva)
{
	if ((uint32_t)kva < KERNBASE)
f010435b:	3d ff ff ff ef       	cmp    $0xefffffff,%eax
f0104360:	77 12                	ja     f0104374 <sched_yield+0x94>
		_panic(file, line, "PADDR called with invalid kva %08lx", kva);
f0104362:	50                   	push   %eax
f0104363:	68 c2 54 10 f0       	push   $0xf01054c2
f0104368:	6a 29                	push   $0x29
f010436a:	68 a4 65 10 f0       	push   $0xf01065a4
f010436f:	e8 74 f8 ff ff       	call   f0103be8 <_panic>
	return (physaddr_t)kva - KERNBASE;
f0104374:	05 00 00 00 10       	add    $0x10000000,%eax
}

static __inline void
lcr3(uint32_t val)
{
	__asm __volatile("movl %0,%%cr3" : : "r" (val));
f0104379:	0f 22 d8             	mov    %eax,%cr3
            cur_task->remind_ticks = TIME_QUANT;
            lcr3(PADDR(cur_task->pgdir));
            env_pop_tf(&cur_task->tf);
f010437c:	83 ec 0c             	sub    $0xc,%esp
f010437f:	83 c2 08             	add    $0x8,%edx
f0104382:	52                   	push   %edx
f0104383:	e8 26 dc ff ff       	call   f0101fae <env_pop_tf>
f0104388:	83 c4 10             	add    $0x10,%esp
f010438b:	e9 5e ff ff ff       	jmp    f01042ee <sched_yield+0xe>
f0104390:	89 0d 38 a0 10 f0    	mov    %ecx,0xf010a038
    if (next_i == -1 ) //only one task can run
                next_i = index;
    if (next_i >= 0 && next_i < NR_TASKS)
            {*/
            
}
f0104396:	83 c4 1c             	add    $0x1c,%esp
f0104399:	5b                   	pop    %ebx
f010439a:	5e                   	pop    %esi
f010439b:	5f                   	pop    %edi
f010439c:	5d                   	pop    %ebp
f010439d:	c3                   	ret    
