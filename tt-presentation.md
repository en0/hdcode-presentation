---
marp: true
class:
    - invert
paginate: true
footer: Ian Laird : 2022
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
- The Cost of Bad Code
- Philosophies of Clean Code
- Responsibility

---

# Intro.get_author()

```java

// Who Am I?
Human author = AuthorBuilder()

    .with_occupation("Software Engineer")
    .with_title("Principal Engineer")
    .with_Employeer("Ericsson BEWS :: Cradlepoint Inc.")
    .with_experience([
        "20 Years",
        "Big Data Analytics",
        "SaaS At Scale",
    ])

    .build()
```

[en0@github](https://github.com/en0)

---

# Signale.handle(SIGHUP)

## One quick thing before we begin:

Let's quickly look at the game we will use in our examples.

[Escape Room Game](https://github.com/en0/esc-game)

---

# Intro.about()

## Quality Code

> __Noun Phrase__. [kwä-lə-tē kōd]
> Code that functions as intended for end-users without any deficiencies.

## Clean Code

> __Noun Phrase__. [klēn kōd]
> Code that is easy to understand and easy to change.

---

# Cost.analyze("CISQ 2020 Report")

## Consortium for Information and Software Quality

> For the year 2020, we determined the total __Cost of Poor Software Quality (CPSQ)__ in the US [was] $2.08 trillion (T).


---

# Cost.analyze("Robert Martin's Case Study")

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

# Business.analyze()

## Developers Are Frustrated

- Everyone is working hard, but progress is slowing down.
- Simple tasks take weeks to complete and cause more bugs.
- The complexity is exhausting, and burnout is frequent.

## Executives Are Concerned

- The cost of production is catching up to revenue.
- Estimated timelines for seemingly simple requests are alarming.
- Leadership begins to lose trust in the technical team.

---

# Code.improve()

__Philosophies of Clean Code__

- Test First
- Refactor, Refactor, Refactor
- Readability Matters
- Abstraction
- Component Level

---

# TestFirst.begin()

Write tests before you write code.

---

# TestFirst.get_example()

```python
def test_get_property_value(self):
    game_object = (
        a.game_object
         .with_property_value("foo", "bar")
         .build()
    )

    self.assert("bar", game_object.get_property("foo"))

...

class GameObject:
    def get_property(self, key: str) -> Any:
        raise NotImplementedError()
```

---

# TestFirst.explain()

1. Ensure code testability
   The code will be testable because you had to test the code to write the code.

2. Provide a complete test suite
   Each method will have a test because you had to test the code to write the code.

3. Reduce cognitive load
   You can focus on the current test scope.

4. Reduce the risk of refactoring
   You will have a complete and dependable set of tests.

---

# Refactoring.explain("refactor risk", page=1)

```python
    def __next__(self) -> Interaction:
        if self._current is None:
            try:
                self._current = next(self._gen)
            except StopIteration:
                raise
            except Exception as ex:
                obj_name, act_name = self._target.get_name(), self._action.get_name()
                raise ActionError(obj_name, act_name) from ex
        elif self._current.get_type() == InteractionResponseType.DONE:
            raise StopIteration()
        elif self._current.get_type() == InteractionResponseType.COLLECT_INPUT:
            try:
                self._current = self._gen.send(self._input)
            except StopIteration:
                raise
            except Exception as ex:
                obj_name, act_name = self._target.get_name(), self._action.get_name()
                raise ActionError(obj_name, act_name) from ex
        else:
            try:
                self._current = next(self._gen)
            except StopIteration:
                raise
            except Exception as ex:
                obj_name, act_name = self._target.get_name(), self._action.get_name()
                raise ActionError(obj_name, act_name) from ex
        self._input = None
        return self
```

---

# TestFirst.explain("refactor risk", page=2)

```python
class InteractionTests(TestCase):

    def test_iterator_returns_first_interaction: ...

    def test_iterator_raises_action_error_on_first_interaction: ...

    def test_iterator_returns_next_interaction: ...

    def test_iterator_raises_action_error_on_next_interaction: ...

    def test_iterator_raises_stop_iterator_when_no_more_interactions: ...

    def test_iterator_accepts_input_on_collect_input_interactions: ...

    def test_iterator_raises_action_error_on_input_interactions: ...

```

---

# Refactor.begin()

> Write tests until fear is transformed into boredom

― Kent Beck, Test-Driven Development: By Example

---

# Refactor.list_steps()

- Ensure Tests Pass
- Ensure Testing Coverage
- Reduce or Isolate Complexity

## GOTO: demo

Use branch `refactor-example` from the [Escape Room Game](https://github.com/en0/esc-game/blob/refactor-example/console-ui/esc/ui/console/game.py#L24)

---

# Refactor.get_example("needs refactor")

```python
    def play(self) -> None:
        self._is_playing = True
        self._room_name = self._prompt.prompt_with_choices(
            message="What room do you want to play?",
            choices=self._room_pack.list_rooms()
        )
        self._game.load_room(self._room_name)
        result = self._game.interact("room", "inspect")
        self._handle_interaction(result)
        while self._is_playing:
            cmd, args = self._prompt.prompt_for_action(self._room_name)
            if cmd == "help":
                self._show_help()
            elif cmd == "quit":
                self._is_playing = False
            else:
                try:
                    result = self._game.interact(args, cmd)
                    self._handle_interaction(result)
                except ObjectNotFoundError:
                    self._print(f"!! What do you want to [{cmd}]?")
                except ActionNotFoundError:
                    self._print(f"!! I don't know how to do that to [{args}]")
```

---

# Refactor.get_example("needs refactor")

```python
    def play(self) -> None:
        self._is_playing = True

        # Prompt user for the room name to play.
        self._room_name = self._prompt.prompt_with_choices(
            message="What room do you want to play?",
            choices=self._room_pack.list_rooms()
        )

        # Load the selected room
        self._game.load_room(self._room_name)

        # Play until player exists
        result = self._game.interact("room", "inspect")
        self._handle_interaction(result)
        while self._is_playing:
            cmd, args = self._prompt.prompt_for_action(self._room_name)

            # Handle special commands
            if cmd == "help":
                self._show_help()
            elif cmd == "quit":
                self._is_playing = False
            else:

                # Handle game interaction
                try:
                    result = self._game.interact(args, cmd)
                    self._handle_interaction(result)
                except ObjectNotFoundError:
                    self._print(f"!! What do you want to [{cmd}]?")
                except ActionNotFoundError:
                    self._print(f"!! I don't know how to do that to [{args}]")
```

---

# Refactor.get_example("refactored")

```python
    def play(self) -> None:
        self._load_room()
        self._play_until_exit()

    def _load_room(self) -> None:
        self._room_name = self._select_room()
        self._game.load_room(self._room_name)

    def _select_room(self) -> str:
        return self._prompt.prompt_with_choices(
            message="What room do you want to play?",
            choices=self._room_pack.list_rooms()
        )

    def _play_until_exit(self) -> None:
        self._is_playing = True
        self._interact_with_room("inspect", "room")
        while self._is_playing:
            cmd, args = self._prompt.prompt_for_action(self._room_name)
            self._handle_user_input(cmd, args)

    def _handle_user_input(self, cmd: str, args: str) -> None:
        if cmd == "help":
            self._show_help()
        elif cmd == "quit":
            self._is_playing = False
        else:
            self._interact_with_room(cmd, args)

    def _interact_with_room(self, cmd, args):
        try:
            result = self._game.interact(args, cmd)
            self._handle_interaction(result)
        except ObjectNotFoundError:
            self._print(f"!! What do you want to [{cmd}]?")
        except ActionNotFoundError:
            self._print(f"!! I don't know how to do that to [{args}]")
```
--- 

# Readability.begin()

> Your code should read like well-written prose.

― Grady Booch

---

# Readability.get_input("option 1")

```python
    def play(self) -> None:
        self._is_playing = True
        self._room_name = self._prompt.prompt_with_choices(
            message="What room do you want to play?",
            choices=self._room_pack.list_rooms()
        )
        self._game.load_room(self._room_name)
        result = self._game.interact("room", "inspect")
        self._handle_interaction(result)
        while self._is_playing:
            cmd, args = self._prompt.prompt_for_action(self._room_name)
            if cmd == "help":
                self._show_help()
            elif cmd == "quit":
                self._is_playing = False
            else:
                try:
                    result = self._game.interact(args, cmd)
                    self._handle_interaction(result)
                except ObjectNotFoundError:
                    self._print(f"!! What do you want to [{cmd}]?")
                except ActionNotFoundError:
                    self._print(f"!! I don't know how to do that to [{args}]")
```

---

# Readability.get_input("option 2")

```python
    def play(self) -> None:
        self._load_room()
        self._play_until_exit()

    def _load_room(self) -> None:
        self._room_name = self._select_room()
        self._game.load_room(self._room_name)

    def _select_room(self) -> str:
        return self._prompt.prompt_with_choices(
            message="What room do you want to play?",
            choices=self._room_pack.list_rooms()
        )

    def _play_until_exit(self) -> None:
        self._is_playing = True
        self._interact_with_room("inspect", "room")
        while self._is_playing:
            cmd, args = self._prompt.prompt_for_action(self._room_name)
            self._handle_user_input(cmd, args)

    def _handle_user_input(self, cmd: str, args: str) -> None:
        if cmd == "help":
            self._show_help()
        elif cmd == "quit":
            self._is_playing = False
        else:
            self._interact_with_room(cmd, args)

    def _interact_with_room(self, cmd, args):
        try:
            result = self._game.interact(args, cmd)
            self._handle_interaction(result)
        except ObjectNotFoundError:
            self._print(f"!! What do you want to [{cmd}]?")
        except ActionNotFoundError:
            self._print(f"!! I don't know how to do that to [{args}]")
```

---

# Readability.explain()

1. Function Names
   Names are concise yet descriptive.

1. Function Size
   Each function is short and does only one thing.

1. Top to Bottom
   Define functions after the first reference.

1. Function Level
   Each function stays at one level of abstraction.

1. No Surprises
   Each function does what one would expect it to do.

---

# Abstraction.begin()

> You cannot reduce the complexity of a software-intensive systems; the best you can do is manage it.

― Grady Booch

---

# Abstraction.get_example()

```python
class EscapeRoomGame(ABC):

    @abstractmethod
    def load_room(self, name: str) -> None:
        raise NotImplementedError()

    @abstractmethod
    def interact(
            self,
            object_name: str,
            action_name: str,
            using_object: str = None,
    ) -> Interaction:
        raise NotImplementedError()
```

---

# Abstraction.explain()

1. Abstractions Define Contracts
   An abstraction is a contract that __unambiguously__ describes behavior.

1. Complexity Isolation
   Abstractions create boundaries. Complexity must not leak through these edges.

1. Cognitive Isolation
   Abstractions let us focus on the current task without getting lost in the weeds.

1. Provide Context
   Abstractions provide context to a system.

---

# Abstraction.explain("isolation")

```python
use_computer_action = UseComputerAction()

computer = (
    GameObjectBuilder()
    .with_name("computer")
    .with_action(use_computer_action)
    .build()
)
```

The `UseComputerAction` is complex. But that complexity does not leak to the rest of the system.

Consider the cognitive load required with the additional complexity of `UseComputerAction`'s details in this code.

---

# Abstraction.explain("context")

```python
class ActionApi(ABC):
    """Api used by Actions to interact with other parts of the game."""

    @abstractmethod
    def get_owner_name(self) -> str:
        raise NotImplementedError()

    @abstractmethod
    def set_object_property(self, object_name: str, key: str, value: Any) -> None:
        raise NotImplementedError()

    @abstractmethod
    def get_object_property(self, object_name: str, key: str) -> None:
        raise NotImplementedError()

    @abstractmethod
    def reveal_child_object(self, object_name: str, child_name: str) -> None:
        raise NotImplementedError()

    @abstractmethod
    def reveal_all_child_objects(self, object_name: str) -> None:
        raise NotImplementedError()
```

---

# ComponentLevel.begin()

> I’m not a great programmer; I’m just a good programmer with great habits.

― Kent Beck

---

# ComponentLevel.define()

## Component Level

> __Noun Phrase__. [kom-poh-nuhnt lev-uhl]
> The distance from the hardware at which some behavior resides.


## I'm not fond of this definition. It's missing something.

---

# ComponentLevel.redefine()

## Component Level

> __Noun Phrase__. [kom-poh-nuhnt lev-uhl]
> The distance from the __I/O__ of a system at some behavior resides.

---

# ComponentLevel.explain()

- What things change most frequently in a system?
- What parts of the system have little to do with business rules?

## The answers to both questions are 

- Things closer to the user.
- Things closer to 3rd party libs.
- Things closer to external APIs.

---

# ComponentLevel.get_example()

- `esc.core` Contains the "Business Rules" of the game.
- `esc.levels` Contains the levels a user can play.
- `esc.ui.console` Contains a console interface to play the game.

What if the Product Team asked us to create a GUI for our game?

What if the Product Team asked us to offer the game on a website?

---

# ComponentLevel.pontificate()

> Frameworks are an implementation detail!

― Robert C. Martin, Clean Architecture

Django, Spring, NHibernate, Entity Framework. These are implementation details and should not affect how we create use cases or how to write business rules.

__Indeed, even the database technology is an implementation detail.__

---

# Bonus.begin()

## Clean Code is for all Programming Paradigms

```
def maintenance_vehicle(vehicle):
    ensure_oil_and_coolent(vehicle)
    ensure_air_filter(vehicle)
    ensure_tire_pressure(vehicle)
    ensure_signals_and_headlines(vehicle)
```

---

# Summary.begin()

> Clean code is not written by following a set of rules. You don’t become a software craftsman by learning a list of heuristics. Professionalism and craftsmanship come from values that drive disciplines.

― Robert C. Martin, Clean Code: A Handbook of Agile Software Craftsmanship

---

# RecommendedReading.list()

- [Refactoring: Improving the Design of Existing Code](https://www.goodreads.com/book/show/44936.Refactoring)
- [Clean Code: A Handbook of Agile Software Craftsmanship](https://www.goodreads.com/book/show/3735293-clean-code)
- [Object-Oriented Analysis and Design with Applications](https://www.goodreads.com/book/show/424923.Object_Oriented_Analysis_and_Design_with_Applications)
- [Test-Driven Development: By Example](https://www.goodreads.com/book/show/387190.Test_Driven_Development)
- [Clean Architecture: A Craftsman's Guide to Software Structure and Design](https://www.goodreads.com/book/show/18043011-clean-architecture)

---

# References.list()

- [Clean Code: A Handbook of Agile Software Craftsmanship](https://www.goodreads.com/book/show/3735293-clean-code)
- [The Total Cost of Owning a Mess](https://www.informit.com/articles/article.aspx?p=1235624&seqNum=3)
- [What Does Bad Coding Look Like](https://webo.digital/blog/what-does-bad-coding-look-like-it-will-always-cost-you-more-in-the-long-run/)
- [CISQ 2020 Report](https://www.it-cisq.org/the-cost-of-poor-software-quality-in-the-us-a-2020-report.htm)
