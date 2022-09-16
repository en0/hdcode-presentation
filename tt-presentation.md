---
marp: true
class:
    - invert
paginate: true
footer: Code Quality : 2022
---

<style>
img[alt~="center"] {
  display: block;
  margin: 0 auto;
}
</style>

# CleanCode { ... }

---

# Outline

- Introduction
- The Cost of Spaghetti
- The power of Abstraction
- Legibility Matters
- Test or Bust
- Responsibility
---

# Intro.author()



```java

// Who Am I?
Human author = AuthorBuilder()

    .with_occupation("Software Engineer")
    .with_title("Principal Engineer")
    .with_experience("20 years", [
            "Computer Hardware/Software",
            "Location-Based SaaS",
            "Real Estate SaaS",
            "International Telecommunications",
    ])

    .build()
```

[en0@github](https://github.com/en0)

---

# Intro.about()

## Clean Code

> __Noun Phrase__. [klēn kōd]
> Code that is easy to understand and easy to change.

## Quality Code

> __Noun Phrase__. [kwä-lə-tē kōd]
> Code that functions as intended for end-users without any deficiencies.

---

# Spaghetti.cost()

_"Clean Architecture: A Craftsman's Guide to Software Structure and Design"_

> As an example, consider the following case study. It includes real data from a
> real company that wishes to remain anonymous.

---

# Spaghetti.cost()

<style scoped>
section {
  padding-top: 100px;
}
h1 {
  position: absolute;
  left: 80px;
  top: 20px;
  right: 80px;
  height: 70px;
  line-height: 70px;
}
</style>
![bg center 60%](/cost_of_a_mess.png)

---

# Spaghetti.analize()

__Developers are frustrated__

- Everyone is working hard but progress is slowing down.
- Simple tasks take weeks to comlete and cause more bugs.
- The complexity is exausting and burnout is frequent.

__Executives are concerned__

- The cost of production is catching up to revenue.
- Estimated timelines for seemingly simple requests are alarming.
- Leadership begins to lose trust in the technical team.

---

# References.list()

- [The Total Cost of Owning a Mess](https://www.informit.com/articles/article.aspx?p=1235624&seqNum=3)
- [What Does Bad Coding Look Like](https://webo.digital/blog/what-does-bad-coding-look-like-it-will-always-cost-you-more-in-the-long-run/)
